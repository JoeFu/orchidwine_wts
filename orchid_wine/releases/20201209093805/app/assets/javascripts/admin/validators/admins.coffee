# #  FORM VALIDATION
# $(document).on 'nifty.ready', ->
#   faIcon = 
#     valid: 'ion-checkmark text-success'
#     invalid: 'ion-close'
#     validating: 'ion-load-d'
  
#   $('#admins-passwd').bootstrapValidator
#     excluded: [':disabled']
#     feedbackIcons: faIcon
#     fields: 
#       old_password:
#         validators:
#           notEmpty:
#             message: '新密码不能为空！'
#        new_password:
#         validators:
#           notEmpty:
#             message: '新密码不能为空！'
#       confirm_new_password:
#         validators:
#           notEmpty:
#             message: '确认密码不能为空！'
#           identical:
#             field: 'new_password',
#             message: '两次输入新密码不一致！'

#   $('#admins-edit').bootstrapValidator
#     excluded: [':disabled']
#     feedbackIcons: faIcon
#     fields: 
#       user_name: 
#         validators: 
#           notEmpty:
#             message: '不能为空！'
#           regexp:
#             regexp: /^[a-zA-Z0-9_\.]+$/
#             message: '只能输入英文或数字'
#       password: 
#         validators: 
#           stringLength:
#             min: 8
#             max: 16
#             message: '密码长度：8-16位！'
#       true_name: 
#         validators: 
#           notEmpty:
#             message: '不能为空！'
#       email: 
#         validators:
#           notEmpty:
#             message: '不能为空！'
#           emailAddress:
#             message: '格式不正确！'
#       mobile: 
#         validators: 
#           notEmpty:
#             message: '不能为空！'
#           stringLength:
#             min: 9
#             max: 11
#             message: '请输入正确格式的手机号码！'
#           regexp:
#             regexp: /^[0-9_\.]+$/
#             message: '请输入正确格式的手机号码！'