area_single = ->
  one = $('select[name=area_id_one]').val()
  two = $('select[name=area_id_two]').val()
  flag = false
  if one == two
    flag = true
  $('input#bulk_wine-area-single').prop('checked', flag);

variety_single = ->
  one = $('select[name=variety_id_one]').val()
  two = $('select[name=variety_id_two]').val()
  three = $('select[name=variety_id_three]').val()
  flag = false
  if one == two && one == three
    flag = true
  $('input#bulk_wine-variety-single').prop('checked', flag);


$(document).on 'nifty.ready', ->
  return
.on 'click', 'input#bulk_wine-area-single', (e) ->
  if this.checked
    v = $('select[name=area_id_one]').val()
    $('select[name=area_id_two]').val(v)

.on 'click', 'input#bulk_wine-variety-single', (e) ->
  if this.checked
    v = $('select[name=variety_id_one]').val()
    $('select[name=variety_id_two]').val(v)
    $('select[name=variety_id_three]').val(v)


.on 'change', 'select[name=area_id_one]', (e) ->
  area_single()
.on 'change', 'select[name=area_id_two]', (e) ->
  area_single()

.on 'change', 'select[name=variety_id_one]', (e) ->
  variety_single()
.on 'change', 'select[name=variety_id_two]', (e) ->
  variety_single()
.on 'change', 'select[name=variety_id_three]', (e) ->
  variety_single()