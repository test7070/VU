<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
            this.errorHandler = null;
            function onPageError(error) {
                alert("An error occurred:\r\n" + error.Message);
            }

            q_tables = 's';
            var q_name = "ina";
            var q_readonly = ['txtNoa','txtComp','txtStore','txtCardeal','txtWorker','txtWorker2'];
			var q_readonlys = ['txtTotal','txtNoq'];
			var bbmNum = [];
			var bbsNum = [];
            var bbmMask = [];
            var bbsMask = [];
            q_sqlCount = 6;
            brwCount = 6;
            brwList = [];
            brwNowPage = 0;
            brwKey = 'Datea';
            aPop = new Array(['txtPost', 'lblPost', 'addr2', 'noa,post', 'txtPost,txtAddr', 'addr2_b.aspx'],
				//['txtTranstartno', 'lblTranstart', 'addr2', 'noa,post','txtTranstartno,txtTranstart', 'addr2_b.aspx'],
				['txtStationno', 'lblStation', 'station', 'noa,station', 'txtStationno,txtStation', 'station_b.aspx'],
				['txtStoreno', 'lblStore', 'store', 'noa,store', 'txtStoreno,txtStore', 'store_b.aspx'],
				['txtRackno', 'lblRackno', 'rack', 'noa,rack,storeno,store', 'txtRackno', 'rack_b.aspx'],
				['txtTggno', 'lblTgg', 'tgg', 'noa,comp', 'txtTggno,txtComp', 'tgg_b.aspx'],
				['txtCardealno', 'lblCardeal', 'cardeal', 'noa,comp', 'txtCardealno,txtCardeal', 'cardeal_b.aspx']//,
				//['txtProductno_', 'btnProductno_', 'ucaucc', 'noa,product,unit', 'txtProductno_,txtProduct_,txtUnit_,txtUcolor_', 'ucaucc_b.aspx']
				);
				
            $(document).ready(function() {
                bbmKey = ['noa'];
                bbsKey = ['noa', 'noq'];
                q_brwCount();
                q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy)
            });

            var abbsModi = [];

            //////////////////   end Ready
            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }

                mainForm(1);
            }

            function mainPost() {
                q_getFormat();
                bbmMask = [['txtDatea', r_picd],['txtTranstart','99:99']];
                q_mask(bbmMask);
                q_gt('ucc', "1=1", 0, 0, 0, "bbsucc");
                q_gt('spec', '1=1 ', 0, 0, 0, "bbsspec");
                q_gt('color', '1=1 ', 0, 0, 0, "bbscolor");
				q_gt('class', '1=1 ', 0, 0, 0, "bbsclass");
                
                bbmNum = [['txtWeight', 15, q_getPara('rc2.weightPrecision'), 1]
                , ['txtMount', 15, q_getPara('rc2.weightPrecision'), 1], ['txtTranstyle', 15, q_getPara('rc2.weightPrecision'), 1], ['txtTotal', 15, q_getPara('rc2.weightPrecision'), 1]
            	, ['txtPrice', 12, 3, 1], ['txtTranmoney', 15, 0, 1]];
                bbsNum = [['txtMount', 15, q_getPara('rc2.mountPrecision'), 1],['txtWeight', 15, q_getPara('rc2.weightPrecision'), 1], ['txtPrice', 15, q_getPara('rc2.pricePrecision'), 1]
				, ['txtTotal', 15, 0, 1], ['txtLengthb', 15, 2, 1]];
                
                
                $('#txtCardealno').change(function(){
					//取得車號下拉式選單
					var thisVal = $(this).val();
					var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
					q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
				});
				
				$('#txtTotal').change(function() {
					if(q_cur==1 || q_cur==2){
						$('#txtMount').val(q_sub(dec($('#txtTotal').val()),dec($('#txtTranstyle').val())));
						$('#txtTranmoney').val(round(q_mul(dec($('#txtPrice').val()),dec($('#txtMount').val())),0))
					}
				});
				$('#txtTranstyle').change(function() {
					if(q_cur==1 || q_cur==2){
						$('#txtMount').val(q_sub(dec($('#txtTotal').val()),dec($('#txtTranstyle').val())));
						$('#txtTranmoney').val(round(q_mul(dec($('#txtPrice').val()),dec($('#txtMount').val())),0))
					}
				});
				$('#txtMount').change(function() {
					if(q_cur==1 || q_cur==2){
						$('#txtTranmoney').val(round(q_mul(dec($('#txtPrice').val()),dec($('#txtMount').val())),0))
					}
				});
				$('#txtPrice').change(function() {
					if(q_cur==1 || q_cur==2){
						$('#txtTranmoney').val(round(q_mul(dec($('#txtPrice').val()),dec($('#txtMount').val())),0))
					}
				});

            }

            function q_boxClose(s2) {///   q_boxClose 2/4
                var ret;
                switch (b_pop) {
                    case q_name + '_s':
                        q_boxClose2(s2);
                        ///   q_boxClose 3/4
                        break;
                }/// end Switch
                b_pop = '';
            }
            
            function q_popPost(s1) {
				switch (s1) {
					case 'txtCardealno':
						//取得車號下拉式選單
						var thisVal = $('#txtCardealno').val();
						var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
						q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
						break;
				}
			}
			
			var carnoList = [];
			var thisCarSpecno = '';
            function q_gtPost(t_name) {
                switch (t_name) {
                	case 'bbsucc':
						var as = _q_appendData("ucc", "", true);
						var t_ucc='@';
						for ( i = 0; i < as.length; i++) {
							t_ucc+=","+as[i].product;
						}
						q_cmbParse("combProduct", t_ucc,'s');
						break;
                	case 'bbsspec':
						var as = _q_appendData("spec", "", true);
						var t_spec='@';
						for ( i = 0; i < as.length; i++) {
							t_spec+=","+as[i].noa;
						}
						q_cmbParse("combSpec", t_spec,'s');
						break;
					case 'bbscolor':
						var as = _q_appendData("color", "", true);
						var t_color='@';
						for ( i = 0; i < as.length; i++) {
							t_color+=","+as[i].color;
						}
						q_cmbParse("combUcolor", t_color,'s');
						break;
					case 'bbsclass':
						var as = _q_appendData("class", "", true);
						var t_class='@';
						for ( i = 0; i < as.length; i++) {
							t_class+=","+as[i].noa;
						}
						q_cmbParse("combClass", t_class,'s');
						break;
                	case 'getCardealCarno' :
						var as = _q_appendData("cardeals", "", true);
						carnoList = as;
						var t_item = " @ ";
						if (as[0] != undefined) {
							for ( i = 0; i < as.length; i++) {
								t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].carno + '@' + as[i].carno;
							}
						}
						for(var k=0;k<carnoList.length;k++){
							if(carnoList[k].carno==$('#txtCarno').val()){
								thisCarSpecno = carnoList[k].carspecno;
								break;
							}
						}
						document.all.combCarno.options.length = 0;
						q_cmbParse("combCarno", t_item);
						$('#combCarno').unbind('change').change(function(){
							if (q_cur == 1 || q_cur == 2) {
								$('#txtCarno').val($('#combCarno').find("option:selected").text());
							}
							for(var k=0;k<carnoList.length;k++){
								if(carnoList[k].carno==$('#txtCarno').val()){
									thisCarSpecno = carnoList[k].carspecno;
									break;
								}
							}
						});
						break;
					case 'btnOk_cubs':
						var as = _q_appendData("view_cubs", "", true);
                        if (as[0] != undefined) {
                        	var t_uno='';
                        	for ( i = 0; i < as.length; i++) {
                        		t_uno=((t_uno.length>0)?',':'')+as[i].uno;
                        	}
                            alert(t_uno+"批號已存在!!");
                        }else{
                        	check_cubs_uno=true;
                        	btnOk();
                        }
                        break;
					case 'btnOk_getuno':
						var as = _q_appendData("view_cubs", "", true);
						var maxnoq=0; 
						if(as[0] != undefined){
							maxnoq=dec(as[0].uno.slice(-3));
						}
						
						//判斷表身批號是否已被使用
						for (var j = 0; j < (q_bbsCount == 0 ? 1 : q_bbsCount); j++) {
							if(replaceAll($('#txtDatea').val(),'/','')+(('000'+maxnoq).slice(-3))==$('#txtUno_'+j).val() && !emp($('#txtUno_'+j).val())){
								maxnoq=maxnoq+1;
							}
						}
						
						//寫入批號
						for (var j = 0; j < (q_bbsCount == 0 ? 1 : q_bbsCount); j++) {
							if(emp($('#txtUno_'+j).val()) && (!emp($('#txtProductno_'+j).val()) || !emp($('#txtProduct_'+j).val()))){
								maxnoq=maxnoq+1;
								$('#txtUno_'+j).val(replaceAll($('#txtDatea').val(),'/','')+(('000'+maxnoq).slice(-3)));
							}
						}
						
						get_maxuno=true;
						btnOk();
						break;
                    case'view_cubs':
						var as = _q_appendData("view_cubs", "", true);
                        if (as[0] != undefined) {
                            alert(as[0].uno+"批號已存在!!");
                            $('#txtUno_' + b_seq).val('');
                        }
                        break;
                    case q_name:
                        if (q_cur == 4)
                            q_Seek_gtPost();
                        break;
                }  /// end switch
            }
			
			var check_cubs_uno=false;
			var get_uno=false,get_maxuno=false;
            function btnOk() {
                t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')],['txtDatea', q_getMsg('lblDatea')]]);
                if (t_err.length > 0) {
                    alert(t_err);
                    return;
                }
                //判斷批號是否已使用
                /*if(!check_cubs_uno){
                	var t_uno = "1=0";
                    for (var i = 0; i < q_bbsCount; i++) {
                        if ($.trim($('#txtUno_' + i).val()).length > 0)
                            t_uno += " or uno='" + $.trim($('#txtUno_' + i).val()) + "'";
                    }
					var t_where = "where=^^ ("+t_uno+") and noa!='"+$('#txtNoa').val()+"' ^^";
					q_gt('view_cubs', t_where, 0, 0, 0, "btnOk_cubs", r_accy);
					return;
                }*/
                
                //判斷是否要產生批號
				/*if(!get_uno){
					for (var j = 0; j < (q_bbsCount == 0 ? 1 : q_bbsCount); j++) {
						if((!emp($('#txtProductno_'+j).val()) || !emp($('#txtProduct_'+j).val()))&& emp($('#txtUno_'+j).val())){
							get_uno=true;
							break;
						}
					}
				}*/
                
                //預設產生批號
                /*if(get_uno && !get_maxuno){
	                var t_where = "where=^^ uno=isnull((select MAX(uno) from view_cubs where uno like '"+replaceAll($('#txtDatea').val(),'/','')+"%' and len(uno)=11),'')  and uno!='' ^^";
					q_gt('view_cubs', t_where, 0, 0, 0, "btnOk_getuno", r_accy);
					return;
                }
                
                check_cubs_uno=false;
                get_uno=false,get_maxuno=false;*/
                
                //檢查是否批號重複
                /*var uno_repeat=false;
                for (var i = 0; i < q_bbsCount; i++) {
                	if(!emp($('#txtUno_'+i).val())){
	                	for (var j = i+1; j < q_bbsCount; j++) {
	                		if($('#txtUno_'+i).val()==$('#txtUno_'+j).val()){
	                			uno_repeat=true;
	                			break;
	                		}
	                	}
                	}
                	if(uno_repeat)
                		break;
                }
                if(uno_repeat){
                	alert("批號重複!!");
                    return;
                }*/
                
                var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
                if (s1.length == 0 || s1 == "AUTO")
                    q_gtnoa(q_name, replaceAll(q_getPara('sys.key_ina')+ $('#txtDatea').val(), '/', ''));
                else
                    wrServer(s1);
            }

            function _btnSeek() {
                if (q_cur > 0 && q_cur < 4)// 1-3
                    return;

                q_box('ina_vu_s.aspx', q_name + '_s', "500px", "400px", q_getMsg("popSeek"));
            }

            function combPay_chg() {
            }

            function bbsAssign() {
                for (var j = 0; j < q_bbsCount; j++) {
                    if (!$('#btnMinus_' + j).hasClass('isAssign')) {
                        //判斷是否重複或已存過入庫----------------------------------------
                        $('#txtUno_' + j).change(function() {
                            t_IdSeq = -1;
                            q_bodyId($(this).attr('id'));
                            b_seq = t_IdSeq;
                            //判斷是否重複
                            for (var k = 0; k < q_bbsCount; k++) {
                                if (k != b_seq && $('#txtUno_' + b_seq).val() == $('#txtUno_' + k).val() && !emp($('#txtUno_' + k).val())) {
                                    alert("批號重複輸入!!");
                                    $('#txtUno_' + b_seq).val('');
                                }
                            }
                            //判斷是否已存過入庫
                            var t_where = "where=^^ uno='" + $('#txtUno_' + b_seq).val() + "' and noa!='"+$('#txtNoa').val()+"' ^^";
                            q_gt('view_cubs', t_where, 0, 0, 0, "", r_accy);
                        });
                        //-------------------------------------------

						
						$('#combUcolor_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtUcolor_'+b_seq).val($('#combUcolor_'+b_seq).find("option:selected").text());
						});
						
						$('#txtSize_' + j).change(function() {
							 if ($(this).val().substr(0, 1) != '#')
                        		$(this).val('#' + $(this).val());
						});
						
						$('#combSpec_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtSpec_'+b_seq).val($('#combSpec_'+b_seq).find("option:selected").text());
						});
						
						$('#combClass_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtClass_'+b_seq).val($('#combClass_'+b_seq).find("option:selected").text());
						});
						
						$('#combProduct_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtProduct_'+b_seq).val($('#combProduct_'+b_seq).find("option:selected").text());
						});
                        //-------------------------------------------------------------------------------------
                    }
                }
                _bbsAssign();
                $('#lblNoq_s').text('項序');
				$('#lblProductno_s').text('品號');
				$('#lblProduct_s').text('品名');
				$('#lblUcolor_s').text('類別');
				$('#lblStyle_s').text('型');
				$('#lblSpec_s').text('材質');
				$('#lblSize_s').text('號數');
				$('#lblLengthb_s').text('米數');
				$('#lblClass_s').text('廠牌');
				$('#lblMount_s').text('數量(件)');
				$('#lblWeight_s').text('重量(KG)');
				$('#lblPrice_s').text('單價');
            }

            function btnIns() {
                _btnIns();

                $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
                $('#txtDatea').val(q_date());
                $('#txtDatea').focus();
            }

            function btnModi() {
                if (emp($('#txtNoa').val()))
                    return;
                _btnModi();
                $('#txtProduct').focus();

            }

            function btnPrint() {
                q_box('z_inap_vu.aspx' + "?;;;;" + r_accy + ";noa=" + trim($('#txtNoa').val()), '', "95%", "650px", q_getMsg("popPrint"));
            }

            function wrServer(key_value) {
                var i;

                $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
                _btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
            }

            function bbsSave(as) {
                if (!as['uno'] && !as['productno'] && !as['product']) {
                    as[bbsKey[1]] = '';
                    return;
                }

                q_nowf();
                as['datea'] = abbm2['datea'];
                as['storeno'] = abbm2['storeno'];
                as['store'] = abbm2['store'];
                return true;
            }

            function refresh(recno) {
                _refresh(recno);

            }

            function readonly(t_para, empty) {
                _readonly(t_para, empty);
            }

            function btnMinus(id) {
                _btnMinus(id);
                sum();
            }

            function btnPlus(org_htm, dest_tag, afield) {
                _btnPlus(org_htm, dest_tag, afield);
            }

            function q_appendData(t_Table) {
                return _q_appendData(t_Table);
            }

            function btnSeek() {
                _btnSeek();
            }

            function btnTop() {
                _btnTop();
            }

            function btnPrev() {
                _btnPrev();
            }

            function btnPrevPage() {
                _btnPrevPage();
            }

            function btnNext() {
                _btnNext();
            }

            function btnNextPage() {
                _btnNextPage();
            }

            function btnBott() {
                _btnBott();
            }

            function q_brwAssign(s1) {
                _q_brwAssign(s1);
            }

            function btnDele() {
                _btnDele();
            }

            function btnCancel() {
                _btnCancel();
            }
			
			function FormatNumber(n) {
				var xx = "";
				if (n < 0) {
					n = Math.abs(n);
					xx = "-";
				}
				n += "";
				var arr = n.split(".");
				var re = /(\d{1,3})(?=(\d{3})+$)/g;
				return xx + arr[0].replace(re, "$1,") + (arr.length == 2 ? "." + arr[1] : "");
			}
		</script>
		<style type="text/css">
            #dmain {
                overflow: hidden;
            }
            .dview {
                float: left;
                width: 98%;
            }
            .tview {
                margin: 0;
                padding: 2px;
                border: 1px black double;
                border-spacing: 0;
                font-size: medium;
                background-color: #FFFF66;
                color: blue;
            }
            .tview td {
                padding: 2px;
                text-align: center;
                border: 1px black solid;
            }
            .dbbm {
                float: left;
                width: 98%;
                margin: -1px;
                border: 1px black solid;
                border-radius: 5px;
            }
            .tbbm {
                padding: 0px;
                border: 1px white double;
                border-spacing: 0;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                background: #cad3ff;
                width: 100%;
            }
            .tbbm tr {
                height: 35px;
            }
            .tbbm tr td {
                width: 9%;
            }
            .tbbm .tdZ {
                width: 2%;
            }
            .tbbm tr td span {
                float: right;
                display: block;
                width: 5px;
                height: 10px;
            }
            .tbbm tr td .lbl {
                float: right;
                color: blue;
                font-size: medium;
            }
            .tbbm tr td .lbl.btn {
                color: #4297D7;
                font-weight: bolder;
                font-size: medium;
            }
            .tbbm tr td .lbl.btn:hover {
                color: #FF8F19;
            }
            .txt.c1 {
                width: 98%;
                float: left;
            }
            .txt.c2 {
                width: 38%;
                float: left;
            }
            .txt.c3 {
                width: 60%;
                float: left;
            }
            .txt.num {
                text-align: right;
            }
            .tbbm td {
                margin: 0 -1px;
                padding: 0;
            }
            .tbbm td input[type="text"] {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                float: left;
            }
            .tbbm select {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                font-size: medium;
            }
            .tbbm textarea {
                font-size: medium;
            }

            input[type="text"], input[type="button"] ,select{
                font-size: medium;
            }
            .dbbs .tbbs {
                margin: 0;
                padding: 2px;
                border: 2px lightgrey double;
                border-spacing: 1px;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                background: #cad3ff;
                width: 100%;
            }
            .dbbs .tbbs tr {
                height: 35px;
            }
            .dbbs .tbbs tr td {
                text-align: center;
                border: 2px lightgrey double;
            }
		</style>
	</head>
	<body>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain'>
			<div class="dview" id="dview" style="float: left;  width:32%;"  >
				<table class="tview" id="tview"   border="1" cellpadding='2'  cellspacing='0' style="background-color: #FFFF66;">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:20%"><a id='vewDatea'> </a></td>
						<td align="center" style="width:25%"><a id='vewTgg'> </a></td>
					</tr>
					<tr>
						<td ><input id="chkBrow.*" type="checkbox" style=' '/></td>
						<td align="center" id='datea'>~datea</td>
						<td align="center" id='comp'>~comp</td>
					</tr>
				</table>
			</div>
			
			<div class='dbbm' style="width: 68%;float:left">
				<table class="tbbm"  id="tbbm"   border="0" cellpadding='2'  cellspacing='0'>
					<tr style="height: 1px;">
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
					</tr>
					<tr>
					<td><span> </span><a id="lblDatea_vu" class="lbl">入庫進貨日期</a></td>
					<td><input id="txtDatea" type="text" class="txt c3"/></td>
					<td><span> </span><a id="lblNoa_vu" class="lbl" >入庫進貨單號</a></td>
					<td><input id="txtNoa" type="text" class="txt c1"/></td>
				</tr>
				<tr>
					<td><span> </span><a id="lblTgg" class="lbl btn"> </a></td>
					<td colspan="3">
						<input id="txtTggno" type="text"  class="txt c2"/>
						<input id="txtComp" type="text"  class="txt c3"/>
					</td>
				</tr>
				<tr>
					<td><span> </span><a id="lblStore" class="lbl btn" > </a></td>
					<td colspan="3">
						<input id="txtStoreno"  type="text"  class="txt c2"/>
						<input id="txtStore"  type="text" class="txt c3"/>
					</td>
				</tr>
				<tr>
					<td><span> </span><a id="lblCardeal" class="lbl btn"> </a></td>
					<td colspan="3">
						<input id="txtCardealno" type="text" class="txt c2"/>
						<input id="txtCardeal" type="text" class="txt c3"/>
					</td>
				</tr>
				<tr>
					<td><span> </span><a id="lblCarno" class="lbl"> </a></td>
					<td>
						<input id="txtCarno" type="text" class="txt" style="width:75%;"/>
						<select id="combCarno" style="width: 20px;"> </select>
					</td>
				</tr>
				<tr>
					<td><span> </span><a id="lblTranstart_vu" class="lbl">入廠時間</a></td>
					<td><input id="txtTranstart" type="text" class="txt c1"/></td>
					<td><span> </span><a id="lblTotal_vu" class="lbl">車總重</a></td>
					<td><input id="txtTotal" type="text" class="txt num c1"/></td>
				</tr>
				<tr>
					<td><span> </span><a id="lblTranstyle_vu" class="lbl" >空重</a></td>
					<td><input id="txtTranstyle" type="text" class="txt num c1"/></td>
					<td><span> </span><a id="lblMount_vu" class="lbl" >淨重</a></td>
					<td><input id="txtMount" type="text" class="txt num c1"/></td>
				</tr>
				<tr>
					<td><span> </span><a id="lblPrice_vu" class="lbl" >應付費用單價</a></td>
					<td><input id="txtPrice" type="text" class="txt num c1" style="width: 130px;"/>/KG</td>
					<td><span> </span><a id="lblTranmoney_vu" class="lbl" >應付運費</a></td>
					<td><input id="txtTranmoney" type="text" class="txt num c1"/></td>
				</tr>
				<tr style="display: none;">
					<td><span> </span><a id="lblOrdeno_vu" class="lbl btn">合約號碼</a></td>
					<td><input id="txtOrdeno" type="text" class="txt c1"/></td>
					<td><span> </span><a id="lblWeight_vu" class="lbl">合約重量</a></td>
					<td><input id="txtWeight" type="text" class="txt num c1"/></td>
				</tr>
				<tr>
					<td><span> </span><a id="lblMemo_vu" class="lbl">備註</a></td>
					<td colspan='3'>
						<textarea id="txtMemo" cols="10" rows="5" style="width: 99%;height: 50px;"> </textarea>
					</td>
				</tr>
				<tr>
					<td><span> </span><a id="lblWorker" class="lbl"> </a></td>
					<td><input id="txtWorker" type="text" class="txt c1"/></td>
					<td><span> </span><a id="lblWorker2" class="lbl"> </a></td>
					<td><input id="txtWorker2" type="text" class="txt c1"/></td>
				</tr>
				<tr style="display: none;">
					<td><span> </span><a id="lblTranstartno_vu" class="lbl">立帳單號</a></td>
					<td><input id="txtTranstartno" type="text" class="txt c1"/></td>
				</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' >
			<table id="tbbs" class='tbbs'  border="1"  cellpadding='2' cellspacing='1'  >
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:1%;"><input class="btn"  id="btnPlus" type="button" value='＋' style="font-weight: bold;"  /></td>
					<td align="center" style="width:55px;"><a id='lblNoq_s'> </a></td>
					<!--<td align="center" style="width:150px;"><a id='lblUno_s'> </a></td>-->
					<!--<td align="center" style="width:150px;"><a id='lblProductno_s'> </a></td>-->
					<td align="center" style="width:150px;"><a id='lblProduct_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblUcolor_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblSpec_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblSize_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblLengthb_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblClass_s'> </a></td>
					<!--<td align="center" style="width:40px;"><a id='lblUnit_s'> </a></td>-->
					<td align="center" style="width:90px;"><a id='lblMount_s'> </a></td>
					<td align="center" style="width:90px;"><a id='lblWeight_s'> </a></td>
					<!--<td align="center" style="width:90px;"><a id='lblPrice_s'> </a></td>-->
					<!--<td align="center" style="width:100px;"><a id='lblTotal_s'> </a></td>-->
					<td align="center" style="width:200px;"><a id='lblMemo_s'> </a></td>
				</tr>
				<tr  style='background:#cad3ff;'>
					<td ><input class="btn"  id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" /></td>
					<td><input id="txtNoq.*" type="text" class="txt c1"/></td>
					<!--<td><input id="txtUno.*" type="text" class="txt c1"/></td>-->
					<!--<td>
						<input id="txtProductno.*" type="text" class="txt c1" style="width: 83%;"/>
						<input class="btn" id="btnProductno.*" type="button" value='.' style="font-weight: bold;" />
					</td>-->
					<td>
						<input id="txtProduct.*" type="text" class="txt c1" style="width: 70%;"/>
						<select id="combProduct.*" class="txt" style="width: 20px;"> </select>
					</td>
					<td>
						<input id="txtUcolor.*" type="text" class="txt c1" style="width: 110px;"/>
						<select id="combUcolor.*" class="txt" style="width: 20px;"> </select>
					</td>
					<td>
						<input id="txtSpec.*" type="text" class="txt c1" style="width: 70%;"/>
						<select id="combSpec.*" class="txt" style="width: 20px;"> </select>
					</td>
					<td><input id="txtSize.*" type="text" class="txt c1" /></td>
					<td><input id="txtLengthb.*" type="text" class="txt num c1" /></td>
					<td>
						<input id="txtClass.*" type="text" class="txt c1" style="width: 70%;"/>
						<select id="combClass.*" class="txt" style="width: 20px;"> </select>
					</td>
					<!--<td><input id="txtUnit.*" type="text" class="txt c1"/></td>-->
					<td><input id="txtMount.*" type="text" class="txt num c1" /></td>
					<td><input id="txtWeight.*" type="text" class="txt num c1" /></td>
					<!--<td><input id="txtPrice.*" type="text" class="txt num c1" /></td>-->
					<!--<td><input id="txtTotal.*" type="text" class="txt num c1" /></td>-->
					<td><input id="txtMemo.*" type="text" class="txt c1"/></td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>