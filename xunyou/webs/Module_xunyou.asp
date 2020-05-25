<!DOCTYPE html
	PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta HTTP-EQUIV="Pragma" CONTENT="no-cache" />
	<meta HTTP-EQUIV="Expires" CONTENT="-1" />
	<link rel="shortcut icon" href="images/favicon.png" />
	<link rel="icon" href="images/favicon.png" />
	<title>软件中心 - 迅游网游加速器</title>
	<link rel="stylesheet" type="text/css" href="index_style.css" />
	<link rel="stylesheet" type="text/css" href="form_style.css" />
	<link rel="stylesheet" type="text/css" href="usp_style.css" />
	<link rel="stylesheet" type="text/css" href="ParentalControl.css">
	<link rel="stylesheet" type="text/css" href="css/icon.css">
	<link rel="stylesheet" type="text/css" href="css/element.css">
	<script type="text/javascript" src="/state.js"></script>
	<script type="text/javascript" src="/popup.js"></script>
	<script type="text/javascript" src="/help.js"></script>
	<script type="text/javascript" src="/validator.js"></script>
	<script type="text/javascript" src="/js/jquery.js"></script>
	<script type="text/javascript" src="/general.js"></script>
	<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
	<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
	<script type="text/javascript" src="/dbconf?p=xunyou&v=<% uptime(); %>"></script>
	<style>
		.Bar_container {
			width: 85%;
			height: 20px;
			border: 1px inset #999;
			margin: 0 auto;
			margin-top: 20px \9;
			background-color: #FFFFFF;
			z-index: 100;
		}

		#proceeding_img_text {
			position: absolute;
			z-index: 101;
			font-size: 11px;
			color: #000000;
			line-height: 21px;
			width: 83%;
		}

		#proceeding_img {
			height: 21px;
			background: #C0D1D3 url(/images/ss_proceding.gif);
		}

		.ddnsto_btn {
			border: 1px solid #222;
			background: linear-gradient(to bottom, #003333 0%, #000000 100%);
			/* W3C */
			font-size: 10pt;
			color: #fff;
			padding: 5px 5px;
			border-radius: 5px 5px 5px 5px;
			width: 16%;
		}

		.ddnsto_btn:hover {
			border: 1px solid #222;
			background: linear-gradient(to bottom, #27c9c9 0%, #279fd9 100%);
			/* W3C */
			font-size: 10pt;
			color: #fff;
			padding: 5px 5px;
			border-radius: 5px 5px 5px 5px;
			width: 16%;
		}

		input[type=button]:focus {
			outline: none;
		}

		.cloud_main_radius_left {
			-webkit-border-radius: 10px 0 0 10px;
			-moz-border-radius: 10px 0 0 10px;
			border-radius: 10px 0 0 10px;
		}

		.cloud_main_radius_right {
			-webkit-border-radius: 0 10px 10px 0;
			-moz-border-radius: 0 10px 10px 0;
			border-radius: 0 10px 10px 0;
		}

		.cloud_main_radius {
			-webkit-border-radius: 10px;
			-moz-border-radius: 10px;
			border-radius: 10px;
		}

		.cloud_main_radius h2 {
			border-bottom: 1px #AAA dashed;
		}

		.cloud_main_radius h3,
		.cloud_main_radius h4 {
			font-size: 12px;
			font-weight: normal;
			font-style: normal;
		}

		.cloud_main_radius h5 {
			color: #FFF;
			font-weight: normal;
			font-style: normal;
		}
	</style>
	<script>
		var $j = jQuery.noConflict();

		function init() {
			show_menu(menu_hook);
			buildswitch();
			version_show();
			var rrt = document.getElementById("switch");
			if (document.form.kms_enable.value != "1") {
				rrt.checked = false;
			} else {
				rrt.checked = true;
			}
			$j('#kms_wan_port').val(db_kms_["kms_wan_port"]);
		}

		function done_validating() {
			return true;
		}

		function buildswitch() {
			$j("#switch").click(
				function () {
					if (document.getElementById('switch').checked) {
						document.form.kms_enable.value = 1;
					} else {
						document.form.kms_enable.value = 0;
					}
				});
		}

		function onSubmitCtrl(o, s) {
			document.form.action_mode.value = s;
			showLoading(3);
			document.form.submit();
		}

		function reload_Soft_Center() {
			location.href = "/Main_Soft_center.asp";
		}

		function version_show() {
			$j("#kms_version_status").html("<i>当前版本：" + db_kms_['kms_version']);
			$j.ajax({
				url: 'https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/kms/config.json.js',
				type: 'GET',
				success: function (res) {
					var txt = $j(res.responseText).text();
					if (typeof (txt) != "undefined" && txt.length > 0) {
						//console.log(txt);
						var obj = $j.parseJSON(txt.replace("'", "\""));
						$j("#kms_version_status").html("<i>当前版本：" + obj.version);
						if (obj.version != db_kms_["kms_version"]) {
							$j("#kms_version_status").html("<i>有新版本：" + obj.version);
						}
					}
				}
			});
		}

		var enable_ss = "<% nvram_get("
		enable_ss "); %>";
		var enable_soft = "<% nvram_get("
		enable_soft "); %>";

		function menu_hook(title, tab) {
			tabtitle[tabtitle.length - 1] = new Array("", "KMS");
			tablink[tablink.length - 1] = new Array("", "Module_kms.asp");
		}
	</script>
</head>

<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
	<form method="POST" name="form" action="/applydb.cgi?p=kms_" target="hidden_frame">
		<input type="hidden" name="current_page" value="Module_kms.asp" />
		<input type="hidden" name="next_page" value="Module_kms.asp" />
		<input type="hidden" name="group_id" value="" />
		<input type="hidden" name="modified" value="0" />
		<input type="hidden" name="action_mode" value="" />
		<input type="hidden" name="action_script" value="" />
		<input type="hidden" name="action_wait" value="5" />
		<input type="hidden" name="first_time" value="" />
		<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get(" preferred_lang "); %>" />
		<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="kms.sh" />
		<input type="hidden" name="firmver" value="<% nvram_get(" firmver "); %>" />
		<input type="hidden" id="kms_enable" name="kms_enable" value='<% dbus_get_def("kms_enable", "0"); %>' />
		<table class="content" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td width="17">&nbsp;</td>
				<td valign="top" width="202">
					<div id="mainMenu"></div>
					<div id="subMenu"></div>
				</td>
				<td valign="top">
					<div id="tabMenu" class="submenuBlock"></div>
					<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
						<tr>
							<td align="left" valign="top">
								<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3"
									class="FormTitle" id="FormTitle">
									<tr>
										< bgcolor="#4D595D" colspan="3" valign="top">
											<div>&nbsp;</div>
											<div style="float:left;" class="formfonttitle">迅游加速器</div>
											<div style="float:right; width:15px; height:25px;margin-top:10px">
												<img id="return_btn" onclick="reload_Soft_Center();" align="right"
													style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;"
													title="返回软件中心" src="/images/backprev.png"
													onMouseOver="this.src='/images/backprevclick.png'"
													onMouseOut="this.src='/images/backprev.png'"></img>
											</div>

											<div style="margin:10px 0 30px 5px;" class="splitLine"></div>

											<img src="https://image.xunyou.com/images/koolshare/softcenter-title.jpg" width="1045" height="487">

											<div class="xunyou_box" style="width: 100%;position: relative;">
												<p>迅游路由器插件，支持三大主机PS4、Xbox、Switch以及PC设备进行加速。</p>
												<p>为流畅游戏提供稳定保障，主机NAT类型ALL Open，一键加速即可畅享！</p>

												<div class="switch_field" style="display:table-cell;float: left;">
													<label for="switch">
														<input id="switch" class="switch" type="checkbox"
															style="display: none;">
														<div class="switch_container">
															<div class="switch_bar"></div>
															<div class="switch_circle transition_style">
																<div></div>
															</div>
														</div>
													</label>
												</div>
											</div>
											<div class="apply_gen">
												<button id="cmdBtn" class="button_gen"
													onclick="onSubmitCtrl(this, ' Refresh ')">提交</button>
											</div>

											<div style="margin:30px 0 30px 5px;" class="splitLine"></div>
										</td>
									</tr>
								</table>
							</td>
							<td width="10" align="center" valign="top"></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
	</td>
	<div id="footer"></div>
</body>

</html>