$(document).on 'nifty.ready', ->
  return true
.on 'click', "form#bulk_wine-edit button[type=submit]", (e) ->
  e.preventDefault()
  e.stopPropagation()
  $('.bottle-c.hide').remove()
  $('.bottle-b.hide').remove()
  $("form#bulk_wine-edit").submit()