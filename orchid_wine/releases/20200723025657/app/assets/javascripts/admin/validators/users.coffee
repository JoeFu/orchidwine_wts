# $(document).on 'nifty.ready', ->
#   faIcon = 
#     valid: 'ion-checkmark text-success'
#     invalid: 'ion-close'
#     validating: 'ion-load-d'

#   $('#users-edit').bootstrapValidator
#     excluded: [':disabled']
#     feedbackIcons: faIcon
#     fields: 
#       user_name: 
#         validators: 
#           notEmpty:
#             message: '不能为空！'
#       name: 
#         validators: 
#           notEmpty:
#             message: '不能为空！'
#       company: 
#         validators: 
#           notEmpty:
#             message: '不能为空！'
#       company_code: 
#         validators: 
#           notEmpty:
#             message: '不能为空！'
#       telphone: 
#         validators: 
#           notEmpty:
#             message: '不能为空！'
#       email: 
#         validators:
#           notEmpty:
#             message: '不能为空！'
#           emailAddress:
#             message: '格式不正确！'