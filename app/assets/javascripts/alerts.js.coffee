$ -> 
  showAlert = (notice, i, arr) ->
    $.bootstrapGrowl notice['text'],
      type: notice['type']
      align: 'center'
      width: 'auto'
      delay: 5000
      allow_dismiss: true
