<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title></title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src="../script/qj2.js" type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src="../script/qj_mess.js" type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
			var q_name = 'cubu', t_bbsTag = 'tbbs', t_content = " ", afilter = [], bbsKey = ['noa'], t_count = 0, as, brwCount = -1;
			brwCount2 = 0;
			var t_sqlname = 'cubu';
			t_postname = q_name;
			var isBott = false;
			var afield, t_htm;
			var i, s1;
			var decbbs = [];
			var decbbm = [];
			var q_readonly = [];
			var q_readonlys = [];
			var bbmNum = [];
			var bbsNum = [];
			var bbmMask = [];
			var bbsMask = [];
			var Parent = window.parent;
			var cubBBsArray = '';
			var cubBBtArray = '';
			if (Parent.q_name && Parent.q_name == 'cub') {
				cubBBsArray = Parent.abbsNow;
				cubBBtArray = Parent.abbtNow;
			}
			aPop = new Array(
				['txtStoreno_', 'btnStoreno_', 'store', 'noa,store', 'txtStoreno_,txtStore_', 'store_b.aspx'],
				['txtProductno_', 'btnProductno_', 'ucaucc', 'noa,product', 'txtProductno_', 'ucaucc_b.aspx']
			);
			$(document).ready(function() {
				bbmKey = [];
				bbsKey = ['noa', 'noq'];
				if (!q_paraChk())
					return;
				main();
			});
			
			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainBrow(6, t_content, t_sqlname, t_postname, r_accy);
				$('#btnTop').hide();
				$('#btnPrev').hide();
				$('#btnNext').hide();
				$('#btnBott').hide();
			}

			function mainPost() {
				bbmMask = [];
				bbsMask = [['txtDatea', r_picd]];
				bbsNum = [['txtMount', 15, q_getPara('rc2.mountPrecision'), 1],['txtWeight', 15, q_getPara('rc2.weightPrecision'), 1], ['txtPrice', 15, q_getPara('rc2.pricePrecision'), 1]
								, ['txtTotal', 15, 0, 1], ['txtLengthb', 15, 2, 1]];
				q_mask(bbmMask);
				parent.$.fn.colorbox.resize({
					height : "750px"
				});
			}
			
			function bbsAssign() {
				_bbsAssign();
				$('#lblDatea_s').text('入庫日期');
				$('#lblUno_s').text('批號');
				$('#lblProductno_s').text('品編');
				$('#lblProduct_s').text('品名');
				$('#lblUcolor_s').text('類別');
				$('#lblStyle_s').text('型');
				$('#lblSpec_s').text('材質');
				$('#lblSize_s').text('號數');
				$('#lblLengthb_s').text('米數');
				$('#lblClass_s').text('廠牌');
				$('#lblUnit_s').text('單位');
				$('#lblMount_s').text('數量');
				$('#lblWeight_s').text('重量');
				$('#lblPrice_s').text('單價');
				$('#lblTotal_s').text('小計');
				$('#lblStore_s').text('倉庫');
				$('#lblMemo_s').text('備註');
				
				SetBBsReadonly(ReadOnlyUno);
				for (var j = 0; j < q_bbsCount; j++) {
					$('#lblNo_' + j).text((j + 1));
					
				}
			}

			function btnOk() {
                t_key = q_getHref();
                _btnOk(t_key[1], bbsKey[0], bbsKey[1], '', 2);
			}
			
			function bbsSave(as) {
				if (!as['uno'] && !as['productno']&& !as['product']) {
					as[bbsKey[0]] = '';
					return;
				}
				q_getId2('', as);
				return true;
			}
			
			var get_uno=false,get_maxuno=false;
			function btnModi() {
				var t_key = q_getHref();
				if (!t_key)
					return;
				_btnModi(1);
				SetBBsReadonly(ReadOnlyUno);
				$('#btnOk').before($('#btnOk').clone().attr('id', 'btnOk2').show()).hide();
				
				$('#btnOk2').click(function() {
					var t_errMsg = '';
					for (var i = 0; i < q_bbsCount; i++) {
						$('#txtWorker_' + i).val(r_name);
						var t_datea = trim($('#txtDatea_' + i).val());
						var t_uno = trim($('#txtUno_' + i).val());
						var t_mount = dec($('#txtMount_' + i).val());
						var t_weight = dec($('#txtWeight_' + i).val());
						if (t_datea.length != 10) {
							if ($.trim(Parent.$('#txtDatea').val()) != '')
								$('#txtDatea_' + i).val($.trim(Parent.$('#txtDatea').val()));
							else
								$('#txtDatea_' + i).val(q_date());
						}
						//不存檔提示!!
						if ((t_mount > 0) && (t_weight <= 0))
							t_errMsg += '第 ' + (i + 1) + " 筆重量小於等於0。\n";
						if ((t_mount > 0) && (t_uno.length == 0))
							t_errMsg += '第 ' + (i + 1) + " 筆批號為空。\n";
					}
					if ($.trim(t_errMsg).length > 0) {
						alert(t_errMsg);
						return;
					}
					//檢查批號
                    for (var i = 0; i < q_bbsCount; i++) {
                        for (var j = i + 1; j < q_bbsCount; j++) {
                            if ($.trim($('#txtUno_' + i).val()).length > 0 && $.trim($('#txtUno_' + i).val()) == $.trim($('#txtUno_' + j).val())) {
                                alert('【' + $.trim($('#txtUno_' + i).val()) + '】' + q_getMsg('lblUno_st') + '重覆。\n' + (i + 1) + ', ' + (j + 1));
                                Unlock(1);
                                return;
                            }
                        }
                    }
                    //parent.$('#txtNoa').val()
                    var t_where = '';
                    for (var i = 0; i < q_bbsCount; i++) {
                        if ($.trim($('#txtUno_' + i).val()).length > 0)
                            t_where += (t_where.length > 0 ? ' or ' : '') + "(uno='" + $.trim($('#txtUno_' + i).val()) + "' and not(accy='" + r_accy + "' and tablea='cubu' and noa='" + $.trim($('#txtNoa_'+i).val()) + "'))";
                    }
                    if (t_where.length > 0)
                        q_gt('view_uccb', "where=^^" + t_where + "^^", 0, 0, 0, 'btnOk_checkuno');
                    else{
                        qbtnOk();
                        parent.$.fn.colorbox.close();
                    }
				});
			}

			function SetBBsReadonly(UnoArr) {
				for (var j = 0; j < UnoArr.length; j++) {
					var thisUno = $.trim(UnoArr[j]);
					for (var k = 0; k < q_bbsCount; k++) {
						var bbsUno = $.trim($('#txtUno_' + k).val());
						if (thisUno == bbsUno) {
							$('#btnMinus_' + k).attr('disabled', 'disabled');
							$('#txtUno_' + k).attr('readonly', true).css({
								'color' : t_color2,
								'background' : t_background2
							});
						}
					}
				}
			}

			function GetBBsUno() {
				var ReturnStr = '';
				var TmpArr = [];
				for (var i = 0; i < q_bbsCount; i++) {
					var thisVal = $.trim($('#txtUno_' + i).val());
					if (thisVal.length > 0) {
						TmpArr.push(thisVal);
					}
				}
				if (TmpArr.length > 0) {
					ReturnStr = "'" + TmpArr.toString().replace(/\,/g, "','") + "'";
					return ReturnStr;
				} else {
					return '';
				}
			}

			function refresh() {
				_refresh();
				$('input[id*="txtProduct_"]').each(function() {
					thisId = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
					$(this).attr('OldValue', $('#txtProductno_' + thisId).val());
				});
				var UnoList = $.trim(GetBBsUno());
				if (UnoList.length > 0) {
					var t_where = 'where=^^ (1=1) and (uno in(' + UnoList + '))^^';
					q_gt('uccy', t_where, 0, 0, 0, 'deleUccy', r_accy);
				}
			}
			
			var t_uccArray = new Array;
			var ReadOnlyUno = [];
			function q_gtPost(t_postname) {
				switch (t_postname) {
				    case 'btnOk_checkuno':
                        var as = _q_appendData("view_uccb", "", true);
                        if (as[0] != undefined) {
                            var msg = '';
                            for (var i = 0; i < as.length; i++) {
                                msg += (msg.length > 0 ? '\n' : '') + as[i].uno + ' 此批號已存在!!\n【' + as[i].action + '】單號：' + as[i].noa;
                            }
                            alert(msg);
                            Unlock(1);
                            return;
                        } else {
                            qbtnOk();
                            parent.$.fn.colorbox.close();
                        }
                        break;
					case 'deleUccy':
						var as = _q_appendData("uccy", "", true);
						if (as[0] != undefined) {
							ReadOnlyUno = new Array;
							for (var i = 0; i < as.length; i++) {
								var asUno = $.trim(as[i].uno);
								if (dec(as[i].gweight) > 0) {
									ReadOnlyUno.push(asUno);
								}
							}
						}
						break;
					case q_name:
						t_uccArray = _q_appendData("ucc", "", true);
						break;
				}  /// end switch
			}

			function q_popPost(s1) {
				switch (s1) {
					
				}
			}
			
			function q_funcPost(t_func, result) {
				switch(t_func) {
					default:
						break;
				}
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
			}

			function btnMinus(id) {
				_btnMinus(id);
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
				if (q_tables == 's')
					bbsAssign();
			}
		</script>
		<style type="text/css">
			input[type="text"], input[type="button"] {
				font-size: medium;
			}
			.txt {
				float: left;
			}
			.c1 {
				width: 98%;
			}
			.c2 {
				width: 85%;
			}
			.c3 {
				width: 71%;
			}
			.c4 {
				width: 95%;
			}
			.num {
				text-align: right;
			}
			#dbbs {
				width: 2200px;
			}
			.btn {
				font-weight: bold;
			}
			#lblNo {
				font-size: medium;
			}
		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div id="dbbs">
			<table id="tbbs" class='tbbs'  border="2"  cellpadding='2' cellspacing='1' style='width:100%;font-size: medium;'>
				<tr style='color:White; background:#003366;' >
					<td align="center"><input class="btn"  id="btnPlus" type="button" value='＋' style="font-weight: bold;"  /></td>
					<td align="center" style="width:15px;"> </td>
					<td align="center" style="width:100px;"><a id='lblDatea_s'> </a></td>
					<td align="center" style="width:200px;"><a id='lblUno_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblProductno_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblProduct_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblUcolor_s'> </a></td>
					<td align="center" style="width:50px;"><a id='lblStyle_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblSpec_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblSize_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblLengthb_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblClass_s'> </a></td>
					<td align="center" style="width:40px;"><a id='lblUnit_s'> </a></td>
					<td align="center" style="width:90px;"><a id='lblMount_s'> </a></td>
					<td align="center" style="width:90px;"><a id='lblWeight_s'> </a></td>
					<td align="center" style="width:90px;"><a id='lblPrice_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblTotal_s'> </a></td>
					<td align="center" style="width:200px;"><a id='lblStore_s'> </a></td>
					<td align="center"><a id='lblMemo_s'> </a></td>
				</tr>
				<tr style="background:#cad3ff;font-size: 14px;">
					<td style="width:1%;"><input class="btn"  id="btnMinus.*" type="button" value="－" style="font-weight: bold;"/></td>
					<td style="text-align:center;">
						<a id="lblNo.*"> </a>
						<input id="txtNoa.*" type="hidden" class="txt c1"/>
						<input id="txtNoq.*" type="hidden" class="txt c1"/>
					</td>
					<td><input id="txtDatea.*" type="text" class="txt c1"/></td>
					<td><input id="txtUno.*" type="text" class="txt c1"/></td>
					<td>
						<input id="txtProductno.*" type="text" class="txt c1" style="width: 83%;"/>
						<input class="btn" id="btnProductno.*" type="button" value='.' style="font-weight: bold;" />
					</td>
					<td><input id="txtProduct.*" type="text" class="txt c1"/></td>
					<td><input id="txtUcolor.*" type="text" class="txt c1"/></td>
					<td><input id="txtStyle.*" type="text" class="txt c1"/></td>
					<td><input id="txtSpec.*" type="text" class="txt c1"/></td>
					<td><input id="txtSize.*" type="text" class="txt c1" /></td>
					<td><input id="txtLengthb.*" type="text" class="txt num c1" /></td>
					<td><input id="txtClass.*" type="text" class="txt c1"/></td>
					<td><input id="txtUnit.*" type="text" class="txt c1"/></td>
					<td><input id="txtMount.*" type="text" class="txt num c1" /></td>
					<td><input id="txtWeight.*" type="text" class="txt num c1" /></td>
					<td><input id="txtPrice.*" type="text" class="txt num c1" /></td>
					<td><input id="txtTotal.*" type="text" class="txt num c1" /></td>
					<td>
						<input id="txtStoreno.*" type="text" class="txt c1" style="width: 30%;"/>
						<input class="btn" id="btnStoreno.*" type="button" value='.' style=" font-weight: bold;float: left;" />
						<input id="txtStore.*" type="text" class="txt c1" style="width: 50%;"/>
					</td>
					<td>
						<input id="txtMemo.*" type="text" class="txt c1"/>
						<input id="txtWorker.*" type="hidden"/>
					</td>
				</tr>
			</table>
			<!--#include file="../inc/pop_modi.inc"-->
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>