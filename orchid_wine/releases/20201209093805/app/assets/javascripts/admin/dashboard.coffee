$(document).on 'nifty.ready', ->
  return true
.on 'change', "select#dashboard-search-sort", (e) ->
  e.preventDefault()
  e.stopPropagation()
  $(this).parents('form').submit()