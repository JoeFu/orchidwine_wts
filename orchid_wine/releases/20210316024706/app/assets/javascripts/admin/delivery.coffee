$(document).on 'nifty.ready', ->
  return
.on 'change', 'select[name=import_company_id]', (e) ->
  $('input[name=import_company_name]').val($(this).find('option:selected').data('name'))
  $('input[name=import_company_contacts]').val($(this).find('option:selected').data('contacts'))
  $('input[name=import_company_telephone]').val($(this).find('option:selected').data('telephone'))
  $('input[name=import_company_email]').val($(this).find('option:selected').data('email'))
  $('input[name=import_company_uscc]').val($(this).find('option:selected').data('uscc'))
  $('input[name=import_company_address]').val($(this).find('option:selected').data('address'))

.on 'change', 'input.container_number_input', (e) ->
  name = $(this).attr('name')
  $('input[name='+name+'_copy]').val($(this).val())

.on 'change', 'input.container_number_input_copy', (e) ->
  name = $(this).attr('name').replace('_copy', '')
  $('input[name='+name+']').val($(this).val())

.on 'click', 'input#seller-checkbox, input#export-checkbox', (e) ->
  id = $(this).attr('id').split('-')[0]
  names = [
    id + '_company_name',
    id + '_company_contacts',
    id + '_company_telephone',
    id + '_company_email',
    id + '_company_abn',
    id + '_company_address',
  ]
  if $(this)[0].checked
    for i in names
      obj = $("input[name=" + i+ "]")
      obj.val(obj.data('default'))
      obj.attr('readonly', 'yes')
  else
    for i in names
      $("input[name=" + i+ "]").removeAttr('readonly')
  return
