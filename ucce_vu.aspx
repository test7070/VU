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
			var q_name = "ucce";
			var q_readonly = ['txtNoa','txtStore'];
			var q_readonlys = ['txtStore'];
			var bbmNum = [];
			var bbsNum = [['txtMount', 10, 2, 1], ['txtPrice', 10, 2, 1], ['txtTotal', 10, 0, 1]];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Datea';
			aPop = new Array(
				['txtStoreno', 'lblStoreno', 'store', 'noa,store', 'txtStoreno,txtStore', 'store_b.aspx'],
				['txtStoreno2', 'lblStore2', 'store', 'noa,store', 'txtStoreno2,txtStore2', 'store_b.aspx'],
				//['txtProductno_', 'btnProduct_', 'ucaucc', 'noa,product,unit,spec', 'txtProductno_,txtProduct_,txtUnit_,txtSpec_,txtUcolor_', 'ucaucc_b.aspx'],
				['txtStoreno_', 'btnStoreno_', 'store', 'noa,store', 'txtStoreno_,txtStore_', 'store_b.aspx']
			);

			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				brwCount2 = 2;
				q_bbsLen = 15;
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
				q_gt('spec', '1=1 ', 0, 0, 0, "bbsspec");
				q_gt('color', '1=1 ', 0, 0, 0, "bbscolor");
				q_gt('class', '1=1 ', 0, 0, 0, "bbsclass");
				q_gt('adpro', '1=1 ', 0, 0, 0, "bbspro");
			});

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(1);
			}

			function mainPost() {
				q_getFormat();
				bbmMask = [['txtDatea', r_picd]];
				q_mask(bbmMask);
				bbsNum = [['txtPrice', 12, q_getPara('rc2.pricePrecision'), 1], ['txtMount', 12, q_getPara('rc2.mountPrecision'), 1], ['txtWeight', 12, q_getPara('rc2.weightPrecision'), 1]
								, ['txtEmount2', 12, q_getPara('rc2.mountPrecision'), 1], ['txtEweight2', 12, q_getPara('rc2.weightPrecision'), 1], ['txtLengthb', 15, 2, 1], ['txtTotal', 15, 0, 1]
								, ['txtLengthc', 12, q_getPara('rc2.mountPrecision'), 1]];
				
				q_cmbParse("cmbKind", q_getPara('ucce.kind'));
				//q_cmbParse("combProduct", q_getPara('rc2s_vu.product'),'s');
				
				var t_where = "where=^^ 1=1 ^^";
				q_gt('ucc', t_where, 0, 0, 0, "");
				
				$('#cmbKind').change(function() {
					for (var j = 0; j < q_bbsCount; j++) {
						btnMinus('btnMinus_' + j);
					}
					product_change();
				});
			}

			function q_boxClose(s2) {
				var
				ret;
				switch (b_pop) {
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				if(s2[0]!=undefined){
					
				}
				b_pop = '';
			}
			
			var a_color='@',a_pro='@';
			function q_gtPost(t_name) {
				switch (t_name) {
					case 'ucc':
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
							a_color+=","+as[i].color;
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
					case 'bbspro':
						var as = _q_appendData("adpro", "", true);
						a_pro='@';
						for (var i = 0; i < as.length; i++) {
							a_pro+=","+as[i].product;
						}
						break;
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
			}

			function btnOk() {
				t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')]]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				var t_storeno = $.trim($('#txtStoreno').val());
				var t_store = $.trim($('#txtStore').val());
				for(var k=0;k<q_bbsCount;k++){
					var bbsStoreno = $.trim($('#txtStoreno_'+k).val());
					if(bbsStoreno.length == 0){
						$('#txtStoreno_'+k).val(t_storeno);
						$('#txtStore_'+k).val(t_store);
					}
				}
				$('#txtWorker').val(r_name);
				//sum();

				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_ucce') + $('#txtDatea').val(), '/', ''));
				else
					wrServer(s1);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;

				q_box('ucce_s.aspx', q_name + '_s', "500px", "310px", q_getMsg("popSeek"));
			}

			function combPay_chg() {
			}

			function bbsAssign() {
				for (var j = 0; j < q_bbsCount; j++) {
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#txtProductno_' + j).bind('contextmenu', function(e) {
                            /*滑鼠右鍵*/
                            e.preventDefault();
                            var n = $(this).attr('id').replace('txtProductno_', '');
                            $('#btnProduct_' + n).click();
                        });
                        $('#txtStoreno_' + j).bind('contextmenu', function(e) {
                            /*滑鼠右鍵*/
                            e.preventDefault();
                            var n = $(this).attr('id').replace('txtStoreno_', '');
                            $('#btnStore_' + n).click();
                        });
                        
                        $('#txtMount_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							var t_unit=trim($('#txtUnit_' + b_seq).val()),t_mount=0;
							if (t_unit.length == 0 || t_unit == 'KG' || t_unit == 'M2' || t_unit == 'M' || t_unit == '批' || t_unit == '公斤' || t_unit == '噸' || t_unit == '頓' || t_unit == 'T') {
								t_mount = $('#txtWeight_' + b_seq).val();
							}else{
								t_mount = $('#txtMount_' + b_seq).val();
							}
							$('#txtTotal_' + b_seq).val(round(q_mul(q_float('txtPrice_' + b_seq), dec(t_mount)), 0));
						});
						
						$('#txtWeight_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							var t_unit=trim($('#txtUnit_' + b_seq).val()),t_mount=0;
							if (t_unit.length == 0 || t_unit == 'KG' || t_unit == 'M2' || t_unit == 'M' || t_unit == '批' || t_unit == '公斤' || t_unit == '噸' || t_unit == '頓' || t_unit == 'T') {
								t_mount = $('#txtWeight_' + b_seq).val();
							}else{
								t_mount = $('#txtMount_' + b_seq).val();
							}
							$('#txtTotal_' + b_seq).val(round(q_mul(q_float('txtPrice_' + b_seq), dec(t_mount)), 0));
						});
						
						$('#txtPrice_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							var t_unit=trim($('#txtUnit_' + b_seq).val()),t_mount=0;
							if (t_unit.length == 0 || t_unit == 'KG' || t_unit == 'M2' || t_unit == 'M' || t_unit == '批' || t_unit == '公斤' || t_unit == '噸' || t_unit == '頓' || t_unit == 'T') {
								t_mount = $('#txtWeight_' + b_seq).val();
							}else{
								t_mount = $('#txtMount_' + b_seq).val();
							}
							$('#txtTotal_' + b_seq).val(round(q_mul(q_float('txtPrice_' + b_seq), dec(t_mount)), 0));
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
						
						$('#combUcolor_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtUcolor_'+b_seq).val($('#combUcolor_'+b_seq).find("option:selected").text());
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
							if(q_cur==1 || q_cur==2){
								$('#txtProduct_'+b_seq).val($('#combProduct_'+b_seq).find("option:selected").text());
								if(q_getPara('sys.project').toUpperCase()=='SF')
									chgcombUcolor(b_seq);
							}
						});
						
						$('#txtProduct_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2){
								if(q_getPara('sys.project').toUpperCase()=='SF')
									chgcombUcolor(b_seq);
							}
						});
					}
				}
				_bbsAssign();
				product_change();
				$('#lblUcolor_s').text('類別');
				$('#lblStyle_s').text('型');
				$('#lblSpec_s').text('材質');
				$('#lblSize_s').text('號數');
				$('#lblLengthb_s').text('米數');
				$('#lblClass_s').text('廠牌');
				$('#lblUnit_s').text('單位');
				$('#lblMount_s').text('件數');
				$('#lblWeight_s').text('重量(KG)');
				$('#lblLengthc_s').text('支數');
				$('#lblUno_s').text('批號');
				
				if(q_cur==1 || q_cur==2){
					for (var j = 0; j < q_bbsCount; j++) {
						if(q_getPara('sys.project').toUpperCase()=='SF'){
							chgcombUcolor(j);
						}
					}
				}
			}
			
			function chgcombUcolor(n) {
				$('#combUcolor_'+n).text('');
				if($('#txtProduct_'+n).val().indexOf('續接')>-1 && $('#txtProduct_'+n).val().indexOf('加工費')>-1)
					q_cmbParse("combUcolor_"+n, ',續接器-直牙(支),續接器-錐牙(支),續接超長5~6M,續接超長6~7M,續接超長7~8M,續接超長(支),組接工資(支),組接超高1.5~1.8M,組接超高1.81~2M,組接超高2M ↑,組接點工');
				else if($('#txtProduct_'+n).val().indexOf('續接')>-1 || $('#txtProduct_'+n).val().indexOf('組接')>-1)
					q_cmbParse("combUcolor_"+n, a_pro);
				else
					q_cmbParse("combUcolor_"+n, a_color);
			}

			function btnIns() {
				_btnIns();
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtDatea').val(q_date());
				$('#txtDatea').focus();
				$('#cmbKind').val(1);
				
				product_change();
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				$('#txtProduct').focus();
				product_change();
			}

			function btnPrint() {
				//q_box('z_uccep.aspx?;;;', '', "95%", "95%", q_getMsg("popPrint"));
			}

			function wrServer(key_value) {
				var i;

				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['productno'] && !as['uno'] && !as['product'] ) {
					as[bbsKey[1]] = '';
					return;
				}

				q_nowf();
				as['datea'] = abbm2['datea'];
				return true;
			}

			function sum() {
				var t1 = 0, t_unit, t_mount, t_weight = 0;
				for (var j = 0; j < q_bbsCount; j++) {
					q_tr('txtTotal_' + j, q_float('txtPrice_' + j) * q_float('txtMount_' + j));
				}

			}

			function refresh(recno) {
				_refresh(recno);
				product_change();
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
			}

			function btnMinus(id) {
				_btnMinus(id);
				//sum();
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

			function product_change() {
				if ($('#cmbKind').val() == '1') {
					aPop = new Array(
						['txtStoreno', 'lblStoreno', 'store', 'noa,store', 'txtStoreno,txtStore', 'store_b.aspx'],
						['txtStoreno2', 'lblStore2', 'store', 'noa,store', 'txtStoreno2,txtStore2', 'store_b.aspx'],
						//['txtProductno_', 'btnProduct_', 'ucaucc', 'noa,product,unit', 'txtProductno_,txtProduct_,txtUnit_', 'ucaucc_b.aspx'],
						['txtStoreno_', 'btnStoreno_', 'store', 'noa,store', 'txtStoreno_,txtStore_', 'store_b.aspx']
					);
				} else if ($('#cmbKind').val() == '2') {
					aPop = new Array(
						['txtStoreno', 'lblStoreno', 'store', 'noa,store', 'txtStoreno,txtStore', 'store_b.aspx'],
						['txtStoreno2', 'lblStore2', 'store', 'noa,store', 'txtStoreno2,txtStore2', 'store_b.aspx'],
						//['txtProductno_', 'btnProduct_', 'bcc', 'noa,product,unit', 'txtProductno_,txtProduct_,txtUnit_', 'bcc_b.aspx'],
						['txtStoreno_', 'btnStoreno_', 'store', 'noa,store', 'txtStoreno_,txtStore_', 'store_b.aspx']
					);
				} else {
					aPop = new Array(
						['txtStoreno', 'lblStoreno', 'store', 'noa,store', 'txtStoreno,txtStore', 'store_b.aspx'],
						['txtStoreno2', 'lblStore2', 'store', 'noa,store', 'txtStoreno2,txtStore2', 'store_b.aspx'],
						//['txtProductno_', 'btnProduct_', 'fixucc', 'noa,namea,unit', 'txtProductno_,txtProduct_,txtUnit_', 'fixucc_b.aspx'],
						['txtStoreno_', 'btnStoreno_', 'store', 'noa,store', 'txtStoreno_,txtStore_', 'store_b.aspx']
					);
				}
				
				if(q_getPara('sys.project').toUpperCase()=='SF'){     
					$('.sf').show();
				}
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
			.txt.c3 {
				width: 80%;
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

			input[type="text"], input[type="button"] {
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
		<div id='dmain' style="width: 100%;">
			<div class="dview" id="dview" style="float: left; width:32%;" >
				<table class="tview" id="tview" border="1" cellpadding='2' cellspacing='0' style="background-color: #FFFF66;">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:20%"><a id='vewNoa'> </a></td>
						<td align="center" style="width:25%"><a id='vewDatea'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=' '/></td>
						<td align="center" id='noa'>~noa</td>
						<td align="center" id='datea'>~datea</td>
					</tr>
				</table>
			</div>
			<div class='dbbm' style="width: 68%;float:left">
				<table class="tbbm" id="tbbm" border="0" cellpadding='2' cellspacing='0'>
					<tr class="tr1">
						<td class='td1'><span> </span><a id="lblNoa" class="lbl"> </a></td>
						<td class='td2'><input id="txtNoa" type="text" class="txt c1"/></td>
						<td class='td3'><span> </span><a id="lblDatea" class="lbl"> </a></td>
						<td class='td4'><input id="txtDatea" type="text" class="txt c1"/></td>
						<td class='td5' style="display: none;"><span> </span><a id="lblKind" class="lbl"> </a></td>
						<td class='td6' style="display: none;"><select id="cmbKind" class="txt c1"> </select></td>
					</tr>
					<tr>
						<td class='td1'><span> </span><a id="lblStoreno" class="lbl btn"> </a></td>
						<td class='td2'>
							<input id="txtStoreno" type="text" class="txt" style="width:30%"/>
							<input id="txtStore" type="text" class="txt" style="width:65%"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' style="min-width: 1900px;"><!--2150px-->
			<table id="tbbs" class='tbbs' border="1" cellpadding='2' cellspacing='1' >
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:1%;">
						<input class="btn" id="btnPlus" type="button" value='+' style="font-weight: bold;" />
					</td>
					<td align="center" style="width:200px;"><a id='lblStoreno_s'> </a></td>
					<td align="center" style="width:150px;display: none;" class="sf"><a id='lblUno_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblProductno_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblUcolor_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblSpec_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblSize_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblLengthb_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblClass_s'> </a></td>
					<!--<td align="center" style="width:55px;"><a id='lblUnit_s'> </a></td>-->
					<td align="center" style="width:85px;display: none;" class="sf"><a id='lblLengthc_s'> </a></td>
					<td align="center" style="width:85px;"><a id='lblEmount2_s'> </a></td>
					<td align="center" style="width:85px;"><a id='lblEweight2_s'> </a></td>
					<td align="center" style="width:85px;"><a id='lblMount_s'> </a></td>
					<td align="center" style="width:85px;"><a id='lblWeight_s'> </a></td>
					<td align="center" style="width:85px;"><a id='lblPrice_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblTotal_s'> </a></td>
					<!--<td align="center" style="width:200px;"><a id='lblUno_s'> </a></td>-->
					<td align="center" style="width:200px;"><a id='lblMemo_s'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td><input class="btn" id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" /></td>
					<td>
						<input id="txtStoreno.*" type="text" style="width:95%;"/>
						<input id="txtStore.*" type="text" style="width:95%;"/>
						<input id="btnStore.*" type="button" style="display:none;" />
					</td>
					<td class="sf" style="display: none;"><input id="txtUno.*" type="text" class="txt c1" style="width: 98%;"/></td>
					<td>
						<!--<input id="txtProductno.*" type="text" style="width:95%;"/>
						<input id="btnProduct.*" type="button" style="display:none;" />-->
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
					<td class="sf" style="display: none;"><input id="txtLengthc.*" type="text" class="txt num c1"/></td>
					<td><input id="txtEmount2.*" type="text" class="txt num c1"/></td>
					<td><input id="txtEweight2.*" type="text" class="txt num c1"/></td>
					<td><input id="txtMount.*" type="text" class="txt num c1"/></td>
					<td><input id="txtWeight.*" type="text" class="txt num c1"/></td>
					<td><input id="txtPrice.*" type="text" class="txt num c1"/></td>
					<td><input id="txtTotal.*" type="text" class="txt num c1"/></td>
					<!--<td><input id="txtUno.*" type="text" class="txt c1"/></td>-->
					<td>
						<input class="txt c1" id="txtMemo.*"type="text" />
						<input id="txtNoq.*" type="hidden" />
					</td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>
