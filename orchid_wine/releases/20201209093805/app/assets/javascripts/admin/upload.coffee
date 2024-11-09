imgUpload = (file) ->
  id = $(file).attr('id')
  progress = '<div class="progress progress-striped active" id="progress-' + id + '"> \
    <div style="width: 10%;" class="progress-bar progress-bar-info"> \
    </div></div>'

  xhr = new XMLHttpRequest()
  uploadUrl = "/admin/uploads/image"
  xhr.open('POST', uploadUrl, true)
  formData = new FormData()
  formData.append('file', $(file)[0].files[0])

  xhr.upload.addEventListener "progress", (evt) ->
    $("button[type=submit]").attr("disabled", 'disabled')

    if (!progressbar)
      $('div#progress-'+id).remove()
      $('#panel-'+ id + ' > .panel-body').after(progress)
      progressbar = $('#progress-'+ id + ' > div')

    if (evt.lengthComputable)
      percentComplete = Math.round(evt.loaded * 100 / evt.total)
      $(progressbar).attr('style', "width: " + percentComplete + "%;")
  , false

  xhr.onreadystatechange = (response) ->
    if (xhr.readyState == 4 && xhr.status == 200 && xhr.responseText != "")
      $("button[type=submit]").removeAttr("disabled")
      $('div#progress-'+id).remove()
      data = JSON.parse(xhr.responseText)
      $('#preview-'+id).html('<img class="preview-img sm" src="' + data.file_path + '"/>')
      $('#hidden-'+id).val(data.file_path)
    else if (xhr.readyState == 4 && xhr.status != 200 && xhr.responseText)
      $('div#progress-'+id).remove()
      $.niftyNoty ->
        type: 'danger'
        container : '#panel-'+id
        html : '上传失败！请重试！或联系技术人员。'
        focus: false
        timer : 5000
  xhr.send(formData);

fileUpload = (file) ->
  id = $(file).attr('id')
  xhr = new XMLHttpRequest()
  uploadUrl = "/admin/uploads/file"
  xhr.open('POST', uploadUrl, true)
  formData = new FormData()
  formData.append('file', $(file)[0].files[0])

  bulk_wine_text = $(this).siblings('i').html()
  xhr.upload.addEventListener "progress", (evt) ->
    $(file).attr("disabled", 'disabled')
    $(this).siblings('i').html('正在上传...')
  , false

  xhr.onreadystatechange = (response) ->
    if (xhr.readyState == 4 && xhr.status == 200 && xhr.responseText != "")
      $(file).removeAttr("disabled")
      $(this).siblings('i').html(bulk_wine_text)
      # $('div#progress-'+id).remove()
      data = JSON.parse(xhr.responseText)
      $('#preview-'+id).html('<a class="btn-link" href="' + data.url + '">' + data.name + '</a>')
      $('#hidden-'+id).val(data.url)
    else if (xhr.readyState == 4 && xhr.status != 200 && xhr.responseText)
      $('div#progress-'+id).remove()
      $.niftyNoty ->
        type: 'danger'
        container : '#panel-'+id
        html : '上传失败！请重试！或联系技术人员。'
        focus: false
        timer : 5000
  xhr.send(formData);

$(document)
  .on "change", "input.img-upload", (e) ->
    imgUpload($(this))
  .on "change", "input.file-upload", (e) ->
    fileUpload($(this))
