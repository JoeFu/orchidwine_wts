$(document)
  .on 'click', 'a.order-confirm', (e) ->
    e.preventDefault()
    e.stopPropagation()
    a_obj = this
    url = $(this).attr('href')
    bootbox.dialog
      message: '<div class="row">
                  <div class="col-sm-11 col-sm-offset-1">
                    <div class="checkbox">
                      <input id="form-checkbox-pay" name="pay_earnest_money" class="magic-checkbox" type="checkbox">
                      <label for="form-checkbox-pay"><b>定金已支付？</b></label>
                    </div>
                    <small id="pay_earnest_money-error" class="hide help-block text-danger">请确认已支付定金，才能下单！</small>
                  </div>
                </div>'
      title: '确认下单后订单细节将不能做更改，确认下单吗？'
      buttons:
        success:
          label: '<i class="btn-label ion-checkmark-circled"></i> 确定下单'
          className: "btn-info"
          callback: ->
            if $('input[name=pay_earnest_money]')[0].checked
              window.location.href = url
            else
              $('#pay_earnest_money-error').removeClass('hide')
              return false

  .on 'click', 'a.order-recheck', (e) ->
    e.preventDefault()
    e.stopPropagation()
    a_obj = this
    url = $(this).attr('href')
    # console.log(url)
    bootbox.dialog
      message: '<div class="row">
                  <div class="col-sm-11 col-sm-offset-1">
                    <div class="checkbox">
                      <input id="form-condition1" name="condition1" class="magic-checkbox" type="checkbox">
                      <label for="form-condition1"><b>合同已完成？</b></label>
                    </div>
                    <small id="condition1-error" class="hide help-block text-danger">请确认合同已完成，才能复核完成！</small>
                  </div>
                  <div class="col-sm-11 col-sm-offset-1">
                    <div class="checkbox">
                      <input id="form-condition2" name="condition2" class="magic-checkbox" type="checkbox">
                      <label for="form-condition2"><b>定金已支付？</b></label>
                    </div>
                    <small id="condition2-error" class="hide help-block text-danger">请确认已支付定金，才能复核完成！</small>
                  </div>

                  <div class="col-sm-11 col-sm-offset-1">
                    <div class="checkbox">
                      <input id="form-condition3" name="condition3" class="magic-checkbox" type="checkbox">
                      <label for="form-condition3"><b>酒标已确认签字？</b></label>
                    </div>
                    <small id="condition3-error" class="hide help-block text-danger">请确认酒标已确认签字，才能复核完成！</small>
                  </div>

                  <div class="col-sm-11 col-sm-offset-1">
                    <div class="checkbox">
                      <input id="form-condition4" name="condition4" class="magic-checkbox" type="checkbox">
                      <label for="form-condition4"><b>定制产品设计稿件已经确认签字？</b></label>
                    </div>
                    <small id="condition4-error" class="hide help-block text-danger">请确认定制产品设计稿件已经确认签字，才能复核完成！</small>
                  </div>
                </div>'
      title: '复核完成后订单细节将不能做更改，是否复核完成？'
      buttons:
        success:
          label: '<i class="btn-label ion-checkmark-circled"></i> 复核完成'
          className: "btn-info"
          callback: ->
            if !$('input[name=condition1]')[0].checked
              $('#condition1-error').removeClass('hide')
              return false
            else
              $('#condition1-error').addClass('hide')

            if !$('input[name=condition2]')[0].checked
              $('#condition2-error').removeClass('hide')
              return false
            else
              $('#condition2-error').addClass('hide')

            if !$('input[name=condition3]')[0].checked
              $('#condition3-error').removeClass('hide')
              return false
            else
              $('#condition3-error').addClass('hide')

            if !$('input[name=condition4]')[0].checked
              $('#condition4-error').removeClass('hide')
              return false
            else
              $('#condition4-error').addClass('hide')
            
            window.location.href = url
