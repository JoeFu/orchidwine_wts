default_packing = {}

abled_bottle_info = ->
	$('select[name=package]').removeAttr('disabled')
	$('select[name=bottle_id]').removeAttr('disabled')
	$('input[name=bottle_type]').removeAttr('disabled')
	$('select[name=cork_id]').removeAttr('disabled')
	$('select[name=cap_id]').removeAttr('disabled')
	$('select[name=cap_color]').removeAttr('disabled')
	$('select[name=divider_id]').removeAttr('disabled')
	$('select[name=carton_id]').removeAttr('disabled')
	$('select[name=cork_print]').removeAttr('disabled')
	$('select[name=bottle_customize]').removeAttr('disabled')
	# $('select[name=cap_print]').removeAttr('disabled')

	$('select[name=bottle_provider]').removeAttr('disabled')
	$('select[name=cork_provider]').removeAttr('disabled')
	$('select[name=cap_provider]').removeAttr('disabled')
	$('select[name=divider_provider]').removeAttr('disabled')
	$('select[name=carton_provider]').removeAttr('disabled')

disabled_bottle_info = () ->
	status = parseInt($("#hidden-status").val())
	return if status > 50

	$('select[name=package]').val(default_packing.package).attr('disabled', 'disabled')
	
	bottle_type = $("input[name=default_bottle_type]").val()
	str = "[value=" + bottle_type + "]"
	$('input[name=bottle_type]').filter(str).prop('checked', true)
	
	$.when(update_bottle_edit()).done ->
		$('input[name=bottle_type]').attr('disabled', 'disabled')
		$('select[name=bottle_id]').val(default_packing.bottle_id).attr('disabled', 'disabled')
		$('select[name=cork_id]').val(default_packing.cork_id).attr('disabled', 'disabled')
		$('select[name=cap_id]').val(default_packing.cap_id).attr('disabled', 'disabled')
		$('select[name=cap_color]').val(default_packing.cap_color).attr('disabled', 'disabled')
		$('select[name=cork_print]').val(default_packing.cork_print).attr('disabled', 'disabled')
		# $('select[name=cap_print]').val(default_packing.cap_print).attr('disabled', 'disabled')
		$('select[name=bottle_customize]').val(default_packing.bottle_customize).attr('disabled', 'disabled')

		$('select[name=bottle_provider]').val(0).attr('disabled', 'disabled')
		$('select[name=cork_provider]').val(0).attr('disabled', 'disabled')
		$('select[name=cap_provider]').val(0).attr('disabled', 'disabled')

		$.when(update_package_edit()).done ->
			$('select[name=divider_id]').val(default_packing.divider_id).attr('disabled', 'disabled')
			$('select[name=carton_id]').val(default_packing.carton_id).attr('disabled', 'disabled')
			$('select[name=divider_provider]').val(0).attr('disabled', 'disabled')
			$('select[name=carton_provider]').val(0).attr('disabled', 'disabled')

disabled_bulk_wine = ->
	$('select[name=sort_id]').attr('disabled', 'disabled')
	$('select[name=year]').attr('disabled', 'disabled')
	$('select[name=variety_id]').attr('disabled', 'disabled')
	$('select[name=bulk_wine_code]').attr('disabled', 'disabled')
	# $('input[name=production_num]').attr('disabled', 'disabled')

abled_bulk_wine = ->
	$('select[name=sort_id]').removeAttr('disabled')
	$('select[name=year]').removeAttr('disabled')
	$('select[name=variety_id]').removeAttr('disabled')
	$('select[name=bulk_wine_code]').removeAttr('disabled')

modal_form_post = (name, html) ->
	bootbox.dialog
		message: html
		title: name
		size: 'large'
		buttons:
			success:
				label: '<i class="btn-label ion-archive"></i> 保存'
				className: "btn-success"
				callback: ->
					$('.bottle-c.hide').remove()
					$('.bottle-b.hide').remove()
					abled_bottle_info()
					abled_bulk_wine()
					$('input[name=default_packing]').remove()
					form = $("#order_productions-edit")
					$.ajax
						type: "POST",
						url: form.attr('action')
						data: form.serialize()
						success: (data) ->
							if (data.code == 0)
								bootbox.alert(data.message);
								console.log(data.message)
							if (data.code == 1)
								window.location.href = data.url

	default_packing = $('input[name=default_packing]').val()
	if default_packing == ''
		default_packing = {}
	else
		default_packing = JSON.parse(default_packing)

	number = parseInt($('#order_productions-edit input[name=production_num]').val())
	custom_number = parseInt($('#order_productions-edit input[name=production_num]').data('custom'))
	if number < custom_number
		disabled_bottle_info()

	status = $("#hidden-status").val()
	console.log(status)
	if status == '51' || status == '52'
		disabled_bulk_wine()

ajax_post_customer = ->
	form = $('form#orders-new')
	return if form.length < 1
	url = form.attr('action').split('?')[0]
	$.ajax
		type: 'post'
		url: url
		data: form.serialize()
		dataType: "json"
		success: (result) ->
			if result.code == 0
			else
				# console.log('客户信息已保存！')
				$.niftyNoty
					type: "success"
					container: "floating"
					icon: 'ion-checkmark'
					title: "自动保存"
					message: "客户信息已保存！"
					closeBtn: true
					timer: 3000

ajax_post_ocean = ->
	form = $('form#orders-new-ocean')
	url = form.attr('action').split('?')[0]
	$.ajax
		type: 'post'
		url: url
		data: form.serialize()
		dataType: "json"
		success: (result) ->
			if result.code == 0
			else
				# console.log('海运信息已保存！')
				$.niftyNoty
					type: "success"
					container: "floating"
					icon: 'ion-checkmark'
					title: "自动保存"
					message: "海运信息已保存！"
					closeBtn: true
					timer: 3000

ajax_post_trade = ->
	form = $('form#orders-new-trade')
	url = form.attr('action').split('?')[0]
	$.ajax
		type: 'post'
		url: url
		data: form.serialize()
		dataType: "json"
		success: (result) ->
			if result.code == 0
			else
				# console.log('出口交易信息已保存！')
				$.niftyNoty
					type: "success"
					container: "floating"
					icon: 'ion-checkmark'
					title: "自动保存"
					message: "出口交易信息已保存！"
					closeBtn: true
					timer: 3000

update_bottle_edit = ->
	type = $('input[name=bottle_type]:checked').val()
	# console.log('bottle_type', type)
	order_production_id = $("input[name=order_production_id]").val()
	$.ajax
		type: 'get'
		url: '/admin/order_productions/'+order_production_id+'/change_bottle_type?bottle_type=' + type
		success: (html) ->
			$('.bottle-b, .bottle-c').remove()
			$('#bottle_type_group').after(html)
			$('.bottle-b, .bottle-c').removeClass('hide')
			$('select[name=bottle_id]').change()

update_package_edit = ->
	type = $('select[name=package]').val()
	# 取瓶子，纸箱，分隔板
	$.ajax
		type: 'get'
		url: "/admin/bottles/select_options?package=" + type
		success: (result) ->
			# $('select[name=bottle_id]').html(result.bottle_options)
			$('select[name=divider_id]').html(result.divider_options)
			$('select[name=carton_id]').html(result.carton_options)

			if result.divider_options == ""
				$('select[name=divider_id]').attr('disabled', 'disabled')
			else
				$('select[name=divider_id]').removeAttr('disabled')

			if result.carton_options == ""
				$('select[name=carton_id]').attr('disabled', 'disabled')
			else
				$('select[name=carton_id]').removeAttr('disabled')

update_boxes = ->
	return
	# number = parseInt($('input[name=production_num]').val())
	# _package = parseInt($('select[name=package]').val())
	# boxes = number / parseInt(_package)
	# if boxes > parseInt(boxes)
	# 	boxes = parseInt(boxes) + 1
	# $('#boxes-info').html(boxes + ' 箱')

update_service_price = (bottle_id, _package, _number)->
	return
	# if bottle_id == '' || bottle_id == undefined || bottle_id == 0 || bottle_id == 'null'
	# 	$("#service-price > span").html(0)
	# 	return
	# $.ajax
	# 	type: 'get'
	# 	url: "/admin/bottles/" + bottle_id + "/service_prices?package=" + _package + "&number=" + _number
	# 	success: (result) ->
	# 		$("#service-price > span").html(result.price)
	# 		update_every_price()
			
update_every_price = ->
	return
	# objs = ['divider','carton','cap','cork']
	# for obj in objs
	# 	price = $("select[name=" + obj + "_id]").find("option:selected").data('price')
	# 	if price == undefined
	# 		price = 0
	# 	$('#' + obj + '-price > span').html(price)
	
	# is_hb = parseInt($('input[name=is_hb]').val())
	# bulkWinePrice = 0
	# if is_hb == 0
	# 	bulkWinePrice = parseFloat($("#bulk_wine-price > span").html())

	# corkPrice = parseFloat($("#cork-price > span").html())
	# cartonPrice = parseFloat($("#carton-price > span").html())
	# dividerPrice = parseFloat($("#divider-price > span").html())
	# capPrice = parseFloat($("#cap-price > span").html())
	# bottlePrice = parseFloat($("#bottle-price > span").html())

	# servicePrice = parseFloat($("#service-price > span").html())
	# _package = parseInt($('select[name=package]').val())

	# servicePrice = servicePrice / _package
	# cartonPrice = cartonPrice / _package

	# totalPrice = bulkWinePrice + servicePrice + corkPrice + cartonPrice + dividerPrice + capPrice + bottlePrice
	# totalPrice = Math.round(totalPrice*Math.pow(10,2))/Math.pow(10,2)
	# # console.log(totalPrice)
	# $("#total-price > span").html(totalPrice)


$(document).on 'nifty.ready', ->
	currentTabIndex = 0
	$('#order-cls-wz').bootstrapWizard
		tabClass: 'wz-steps'
		nextSelector: '.next'
		previousSelector: '.previous'
		onTabClick: (tab, navigation, index) ->
			# console.log('onTabClick', index)
			order_id = $('input[name=order_id]').val()
			if order_id
				if index == 0
					ajax_post_customer()
				if index == 2
					ajax_post_ocean()
				if index == 3
					ajax_post_trade()
				return true
			else
				$('#orders-new-customer-error').removeClass('hide')
				return false
		onInit: ->
			url_string = window.location.href
			url = new URL(url_string);
			c = url.searchParams.get("step");

			$('#order-cls-wz').find('.finish').hide().prop('disabled', true)
		onTabShow: (tab, navigation, index) ->
			# console.log('onTabShow', index)
			if currentTabIndex != index
				stateObj = { foo: 'step' };
				history.pushState(stateObj, "", window.location.pathname + '?step=' + index);
			currentTabIndex = index
			total = navigation.find('li').length
			current = index + 1
			percent = (current / total) * 100
			wdt = 100 / total
			lft = wdt * index
			$('#order-cls-wz').find('.progress-bar').css({width: percent+'%'})
			if (current >= total)
				$('#order-cls-wz').find('.next').hide()
				$('#order-cls-wz').find('.finish').show()
				$('#order-cls-wz').find('.finish').prop('disabled', false)
			else
				$('#order-cls-wz').find('.next').show()
				$('#order-cls-wz').find('.finish').hide().prop('disabled', true)
		onNext: (tab, navigation, index) ->
			# console.log('next', index)
			if (index == 1)
				order_id = $('input[name=order_id]').val()
				if order_id
					ajax_post_customer()
				else
					$('#orders-new').submit()
			if (index == 3)
			  ajax_post_ocean()
				# $('#orders-new-ocean').submit()

.on 'click', '#orders-new-finish', (e) ->
	$('#orders-new-trade').submit()
	# ajax_post_ocean()
	# $('#orders-new-ocean').submit()

.on 'click', '.order-new-pedit', (e) ->
	id = $(this).data('id')
	url = '/admin/order_productions/' + id + '/modal'
	this_btn = $(this)
	this_btn.attr('disabled', 'disabled')
	$.ajax
		type: 'get'
		url: url
		success: (html) ->
			modal_form_post('编辑产品', html)
			this_btn.removeAttr('disabled')

.on 'change', 'select[name=package]', (e) ->
	update_package_edit()
	# type = $(this).val()
	# # 取瓶子，纸箱，分隔板
	# $.ajax
	# 	type: 'get'
	# 	url: "/admin/bottles/select_options?package=" + type
	# 	success: (result) ->
	# 		# $('select[name=bottle_id]').html(result.bottle_options)
	# 		$('select[name=divider_id]').html(result.divider_options)
	# 		$('select[name=carton_id]').html(result.carton_options)

	# 		if result.divider_options == ""
	# 			$('select[name=divider_id]').attr('disabled', 'disabled')
	# 		else
	# 			$('select[name=divider_id]').removeAttr('disabled')

	# 		if result.carton_options == ""
	# 			$('select[name=carton_id]').attr('disabled', 'disabled')
	# 		else
	# 			$('select[name=carton_id]').removeAttr('disabled')

	# update_boxes()
	# bottle_id = $('select[name=bottle_id]').val()
	# _number = $('input[name=production_num]').val()
	# update_service_price(bottle_id, type, _number)

.on 'change', 'input[name=bottle_type]', (e) ->
	update_bottle_edit()

.on 'change', 'select[name=bottle_id]', (e) ->
	return
	# bottle_id = $(this).val()
	# price = $(this).find("option:selected").data('price')
	# if price == undefined
	# 	price = 0
	# $('#bottle-price > span').html(price)
	# # 取服务费
	# _package = $('select[name=package]').val()
	# $('#service-price > b').html(_package)
	# _number = $('input[name=production_num]').val()
	# update_service_price(bottle_id, _package, _number)

.on 'change', 'select[name=divider_id]', (e) ->
	update_every_price()
.on 'change', 'select[name=carton_id]', (e) ->
	update_every_price()
.on 'change', 'select[name=cap_id]', (e) ->
	update_every_price()
.on 'change', 'select[name=cork_id]', (e) ->
	update_every_price()

.on 'click', '#order-new-create', (e) ->
	e.preventDefault()
	e.stopPropagation()
	url = $(this).attr('href')
	this_btn = $(this)
	this_btn.attr('disabled', 'disabled')
	$.ajax
		type: 'get'
		url: url
		success: (html) ->
			if (html.code == 0)
				bootbox.alert(html.message);
			else
				modal_form_post('添加产品', html)
				this_btn.removeAttr('disabled')

.on 'change', '#order_productions-edit select[name=sort_id], #order_productions-edit select[name=year], #order_productions-edit select[name=variety_id]', (e) ->
	sort_id = $('#order_productions-edit select[name=sort_id]').val()
	year = $('#order_productions-edit select[name=year]').val()
	variety_id = $('#order_productions-edit select[name=variety_id]').val()
	url = '/admin/bulk_wines/get_json?sort_id=' + sort_id + '&year=' + year + '&variety_id=' + variety_id
	$.ajax
		type: 'get'
		url: url
		success: (result) ->
			if result.code == 1
				$('#order_productions-edit select[name=bulk_wine_code]').html(result.data).change()

.on 'change', '#order_productions-edit select[name=bulk_wine_code]', (e) ->
	bulk_wine_code = $(this).val()
	# price = $(this).find("option:selected").data('price')
	# if price == undefined
	# 	price = 0
	# $('#bulk_wine-price > span').html(price)
	
	if bulk_wine_code != '0' && bulk_wine_code != ''
		url = '/admin/bulk_wine_stocks/get_json?bulk_wine_code=' + bulk_wine_code
		$.ajax
			type: 'get'
			url: url
			success: (result) ->
				if result.code == 0
					bootbox.alert(result.message);
				else
					str = '可用剩余库存：' + result.data.stock + ' 瓶。<br>'
					str += '下单起量：' + result.data.min_number + ' 瓶，'
					str += '自定义包材起量：' + result.data.custom_number + ' 瓶。'
					$("#stock-info").html(str)
					production_num = parseInt($('input[name=production_num]').val())
					$('input[name=production_num]').data('custom', result.data.custom_number)
					if production_num < 1
						$('input[name=production_num]').val(result.data.min_number)

					type = result.data.bottle_code.slice(-1)
					$("input[name=default_bottle_type]").val(type)

					default_packing = result.data
					if result.data.custom_number > production_num
						disabled_bottle_info()
					else
						abled_bottle_info()
					update_every_price()
					# update_boxes()

.on 'change', '#order_productions-edit input[name=production_num]', (e) ->
	number = parseInt($(this).val())
	custom_number = parseInt($(this).data('custom'))
	is_hb = parseInt($("input[name=is_hb]").val())

	if is_hb == 1 || number >= custom_number
		abled_bottle_info()
	else
		disabled_bottle_info()

	bottle_id = $('select[name=bottle_id]').val()
	_package = $('select[name=package]').val()
	# update_boxes()
	update_service_price(bottle_id, _package, number)

# 编辑生产类型
.on 'change', 'select[name=produce_type]', (e) ->
	order_product_id = $(this).data('order_product_id')
	produce_type = $(this).val();
	$.ajax
		url: '/admin/order_productions/' + order_product_id + '/produce_type',
		method: 'post',
		async: false,
		data: 'produce_type=' + produce_type,
		success: (json) ->
			if json.code == 0
			else
				$.niftyNoty
					type: 'success',
					icon: 'ion-checkmark'
					message: "生产类型，修改成功！",
					container: "floating"
					timer: 10000
