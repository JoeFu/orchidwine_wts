# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document)
  # .on "click", "a.mainnav-toggle", (e) ->
  #   # console.log(11)
  #   document.cookie = "mainnav=sm;"

  .on 'change', 'select[name=provience_id]', (e) ->
    e.preventDefault()
    e.stopPropagation()
    father_id = $(this).val()
    $.ajax
      url: '/admin/areas/cities'
      dataType: "html"
      data: 'father_id=' + father_id
      error: ->
        # console.log(error)
      success: (result) ->
        $('select[name=city_id').html(result).selectpicker('refresh')
    return

  .on 'change', 'select[name=city_id]', (e) ->
    e.preventDefault()
    e.stopPropagation()
    father_id = $(this).val()
    # console.log(222)
    $.ajax
      url: '/admin/areas/counties'
      dataType: "html"
      data: 'father_id=' + father_id
      error: ->
        # console.log(error)
      success: (result) ->
        $('select[name=area_id').html(result).selectpicker('refresh')
    return
  .on "click", "button.show-progress-log", (e) ->
    $(this).siblings('.progress-log').toggle()

  .on 'nifty.ready', ->
    error = $('input#flash-error').val()
    success = $('input#flash-success').val()
    if error
      $.niftyNoty
        type: "danger"
        container: "#page-content"
        # container: "floating"
        icon: 'ion-flash'
        title: "操作失败提醒！"
        message: error
        closeBtn: true
        timer: 10000

    if success
      $.niftyNoty
        type: "success"
        # container: "#page-content"
        container: "floating"
        icon: 'ion-checkmark'
        title: "操作成功提示！"
        message: success
        closeBtn: true
        timer: 10000

    $('select.chosen-select').chosen()
    $('.input-daterange').datepicker
      format: "yyyy-mm-dd"
      todayBtn: false
      autoclose: true
      todayHighlight: true
      language: "zh-CN"
      maxDate: $.now()
    $('.input-timepicker').timepicker
      minuteStep: 5
      showInputs: false
      disableFocus: true
      showMeridian: false
      defaultTime: '12:00 AM'

  # .on 'change', 'input#import-hb-service-price', (e) ->
  #   file = $(this)[0].files[0]
  #   xhr = new XMLHttpRequest()
  #   uploadUrl = '/admin/bottles/service_fee_upload'
  #   xhr.open('POST', uploadUrl, true)
  #   formData = new FormData()
  #   formData.append('file', $(this)[0].files[0])

  #   xhr.upload.addEventListener "progress", (evt) ->
  #     # $('#importing-orders').show()
  #     return true
  #   , false

  #   xhr.onreadystatechange = (response) ->
  #     if (xhr.readyState == 4 && xhr.status == 200 && xhr.responseText != "")
  #       # $("button[type=submit]").removeAttr("disabled")
  #       # $(progress).remove();
  #       data = JSON.parse(xhr.responseText);
  #       # console.log(data)
  #       # $('#importing-orders').hide()
  #       if data.success == true
  #         window.location.href = '/admin/bottles?tab=hb-service-fee'; 
  #     else if (xhr.readyState == 4 && xhr.status != 200 && xhr.responseText)
  #       alert('上传失败')
  #   xhr.send(formData)

return 