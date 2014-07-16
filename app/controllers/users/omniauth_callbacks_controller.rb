# encoding: utf-8
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    oauthorize 'github'
  end
  
  def facebook
    oauthorize 'facebook'
  end
  
  def gplus
    oauthorize 'googleplus'
  end

  def vkontakte
    oauthorize 'vk'
  end
  
  def passthru
    render file: "#{Rails.root}/public/404.html", status: 404, layout: false
  end

  private

  def oauthorize(kind)
    @user = find_for_ouath(kind, env['omniauth.auth'], current_user)
    if @user
      flash[:success] = I18n.t('devise.omniauth_callbacks.success', kind: kind)
      session["devise.#{kind.downcase}_data"] = env['omniauth.auth']
      sign_in_and_redirect @user, event: :authentication
    end    
  end

  def find_for_ouath(provider, access_token, resource = nil)
    user, email, first_name, last_name, uid, acc_attrs = nil, nil, nil, nil, {}

    case provider
    when 'github'
      uid        = access_token['uid']
      first_name = access_token['extra']['raw_info']['first_name']
      last_name  = access_token['extra']['raw_info']['last_name']
      email      = access_token['info']['email']
      acc_attrs  = { uid:        uid,
                     nickname:   access_token['extra']['raw_info']['screen_name'], 
                     token:      access_token['credentials']['token'], 
                     secret:     nil, 
                     first_name: first_name, 
                     last_name:  last_name, 
                     link:       access_token['info']['urls']['Vkontakte'],
                     photo_url:  access_token['info']['image'] }

    when 'vk'
      uid        = access_token['uid']
      first_name = access_token['extra']['raw_info']['first_name']
      last_name  = access_token['extra']['raw_info']['last_name']
      email      = access_token['info']['email']
      acc_attrs  = { uid:        uid,
                     nickname:   access_token['extra']['raw_info']['screen_name'], 
                     token:      access_token['credentials']['token'], 
                     secret:     nil, 
                     first_name: first_name, 
                     last_name:  last_name, 
                     link:       access_token['info']['urls']['Vkontakte'],
                     photo_url:  access_token['info']['image'] }

    when 'facebook'
      uid        = access_token['uid']
      first_name = access_token['info']['first_name']
      last_name  = access_token['info']['last_name']
      email      = access_token['info']['email']
      acc_attrs  = { uid:        uid,
                     nickname:   access_token['info']['nickname'], 
                     token:      access_token['credentials']['token'], 
                     secret:     nil, 
                     first_name: first_name, 
                     last_name:  last_name, 
                     link:       access_token['extra']['raw_info']['link'],
                     photo_url:  access_token['info']['image'] }

    when 'googleplus'
      uid        = access_token['uid']
      first_name = access_token['info']['first_name']
      last_name  = access_token['info']['last_name']
      email      = access_token['info']['email']
      acc_attrs  = { uid:        uid,
                     nickname:   nil,
                     token:      access_token['credentials']['token'],
                     secret:     nil,
                     first_name: first_name,
                     last_name:  last_name,
                     link:       access_token['info']['urls']['Google+'],
                     photo_url:  access_token['info']['image'] }

    else
      raise "Provider #{provider} not handled"
    end

    # Если пользователь не авторизован
    if resource.nil?
      if email.present?
        user = find_for_oauth_by_email(email, resource)
      end

      if user.nil? && uid.present?
        user = find_for_oauth_by_uid(uid, resource)
      end

      if user.nil?
        user = find_for_oauth_by_first_name_and_last_name(first_name, last_name, email, resource)
      end
    else
      user = resource
    end
    
    # Ищем аккаунт пользователя с текущим провайдером
    acc = user.accounts.find_by_provider(provider)
    if acc.nil?
      acc = user.accounts.build(provider: provider)
      user.accounts << acc
    end
    acc.update_attributes acc_attrs
    
    user
  end

  def find_for_oauth_by_uid(uid, resource = nil)
    user = nil
    if acc = Account.find_by_uid(uid.to_s)
      user = acc.user
    end
    user
  end

  def find_for_oauth_by_email(email, resource = nil)
    User.find_by_email(email)
  end
  
  def find_for_oauth_by_first_name_and_last_name(first_name, last_name, email, resource = nil)
    if user = User.find_by_first_name_and_last_name(first_name, last_name)
      user
    else
      user = User.new(first_name: first_name, last_name: last_name, email: email.presence)
      user.save(validate: false)
    end
    user
  end

  def sign_in_and_redirect(resource_or_scope, *args)
    if user_signed_in?
      redirect_to account_settings_url(subdomain: 'www')
    else
      options  = args.extract_options!
      scope    = Devise::Mapping.find_scope!(resource_or_scope)
      resource = args.last || resource_or_scope
      sign_in(scope, resource, options)
      redirect_to after_sign_in_path_for(resource)
    end
  end

end