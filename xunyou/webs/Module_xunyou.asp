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
	<title>软件中心 - 迅游加速器</title>
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
	<script type="text/javascript" src="/dbconf?p=xunyou_&v=<% uptime(); %>"></script>
	<script>
		var $j = jQuery.noConflict();

		function init() {
			show_menu(menu_hook);
			buildswitch();
			version_show();
			var rrt = document.getElementById("switch");
			if (document.form.xunyou_enable.value != "1") {
				rrt.checked = false;
			} else {
				rrt.checked = true;
			}
		}

		function buildswitch() {
			$j("#switch").click(function () {
					if (document.getElementById('switch').checked) {
						document.form.xunyou_enable.value = 1;
					} else {
						document.form.xunyou_enable.value = 0;
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

		var enable_ss = "<% nvram_get(" enable_ss "); %>";
		var enable_soft = "<% nvram_get(" enable_soft "); %>";

		function menu_hook(title, tab) {
			tabtitle[tabtitle.length - 1] = new Array("", "迅游加速器");
			tablink[tablink.length - 1] = new Array("", "Module_xunyou.asp");
		}
	</script>
</head>

<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
	<form method="POST" name="form" action="/applydb.cgi?p=xunyou_" target="hidden_frame">
		<input type="hidden" name="current_page" value="Module_xunyou.asp" />
		<input type="hidden" name="next_page" value="Module_xunyou.asp" />
		<input type="hidden" name="group_id" value="" />
		<input type="hidden" name="modified" value="0" />
		<input type="hidden" name="action_mode" value="" />
		<input type="hidden" name="action_script" value="" />
		<input type="hidden" name="action_wait" value="5" />
		<input type="hidden" name="first_time" value="" />
		<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get(" preferred_lang "); %>" />
		<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="xunyou.sh" />
		<input type="hidden" name="firmver" value="<% nvram_get(" firmver "); %>" />
		<input type="hidden" id="xunyou_enable" name="xunyou_enable" value='<% dbus_get_def("xunyou_enable", "0"); %>' />
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

												<div class="switch_field" style="position: absolute;width: 50px;height: 30px;background-color: blue;top: 20px;right: 5px;">
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
													onclick="window.location.href = 'http://router.xunyou.com/dist/login.html?action=1'">前往设置</button>
											</div>

											<div style="margin:30px 0 30px 5px;" class="splitLine"></div>

											<div class="KoolshareBottom">
												<br/>论坛技术支持：
												<a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> 
												</a>
												<br/>后台技术支持： <i>Xiaobao</i> 
												<br/>Shell, Web by： <i>fw867</i>
												<br/>
											</div>
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