# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Xform = (el) ->
  this.url = $(el).attr('href')
  this.deleteHtml = '<form action="'+this.url+'" method="post"> \
              <input type="hidden" name="_method" value="delete"/> \
              </form>'
  
  this.patchHtml = '<form action="'+this.url+'" method="post"> \
              <input type="hidden" name="_method" value="patch"/> \
              </form>'

  this.putHtml = '<form action="'+this.url+'" method="post"> \
              <input type="hidden" name="_method" value="put"/> \
              </form>'
  return

Xform.prototype =
  deleteSubmit: ->
    form = $(this.deleteHtml)
    bootbox.confirm
      message: "确定删除吗?"
      buttons:
        confirm:
          label: '确定'
          className: 'btn-danger'
        cancel:
          label: '取消'
      callback: (result) ->
        if (result)
          $(document.body).append(form)
          form.submit()
    return

  patchSubmit: (str = '') ->
    form = $(this.patchHtml)
    if (str != '' && str != 'undefined')
      bootbox.confirm
        message: "确定" + str + "吗?"
        buttons:
          confirm:
            label: '确定'
            className: 'btn-danger'
          cancel:
              label: '取消'
        callback: (result) ->
          if (result)
            $(document.body).append(form)
            form.submit()
    else
      $(document.body).append(form)
      form.submit()
    return

  putSubmit: ->
    form = $(this.putHtml)
    $(document.body).append(form)
    form.submit()
    return

$(document)
  .on "click", "a.mtd-patch", (e) ->
    e.preventDefault()
    str = $(this).data('option')
    new Xform(this).patchSubmit(str)

  .on "click", "a.mtd-put", (e) ->
    e.preventDefault()
    new Xform(this).putSubmit()

  .on "click", "a.mtd-delete", (e) ->
    e.preventDefault()
    new Xform(this).deleteSubmit()