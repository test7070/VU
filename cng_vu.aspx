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
			var q_name = "cng";
			var q_readonly = ['txtNoa','txtTgg','txtCardeal','txtStorein','txtStore','txtNamea', 'txtWorker', 'txtWorker2', 'txtTranstart', 'txtAddr'];
			var q_readonlys = [];
			var bbmNum = [];
			var bbsNum = [];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Datea';
			aPop = new Array(
				//['txtPost', 'lblPost', 'addr', 'post,addr', 'txtPost', 'addr_b.aspx'],
				['txtPost', 'lblPost', 'addr', 'noa,post', 'txtPost,txtAddr', 'addr2_b.aspx'],
				['txtTranstartno', 'lblTranstart', 'addr2', 'noa,post','txtTranstartno,txtTranstart', 'addr2_b.aspx'],
				['txtStoreno', 'lblStore', 'store', 'noa,store', 'txtStoreno,txtStore', 'store_b.aspx'],
				//['txtRackno', 'lblRackno', 'rack', 'noa,rack,storeno,store', 'txtRackno', 'rack_b.aspx'],
				['txtStoreinno', 'lblStorein', 'store', 'noa,store', 'txtStoreinno,txtStorein', 'store_b.aspx'],
				//['txtRackinno', 'lblRackinno', 'rack', 'noa,rack,storeno,store', 'txtRackinno', 'rack_b.aspx'],
				['txtTggno', 'lblTgg', 'tgg', 'noa,nick', 'txtTggno,txtTgg', 'tgg_b.aspx'],
				['txtCardealno', 'lblCardeal', 'cardeal', 'noa,comp', 'txtCardealno,txtCardeal', 'cardeal_b.aspx'],
				//['txtProductno_', 'btnProductno_', 'ucaucc', 'noa,product,unit,spec', 'txtProductno_,txtProduct_,txtUnit_,txtSpec_,txtUcolor_', 'ucaucc_b.aspx'],
				['txtMemo', '', 'qphr', 'noa,phr', '0,txtMemo', ''],
				['txtSssno', 'lblSssno', 'sss', 'noa,namea', 'txtSssno,txtNamea', 'sss_b.aspx'],
				['txtUno_', '', 'view_uccc2', 'uno,uno,product,spec,size,lengthb,class,ucolor,unit,emount,eweight'
				,'0txtUno_,txtUno_,txtProduct_,txtSpec_,txtSize_,txtLengthb_,txtClass_,txtUcolor_,txtUnit_,txtMount_,txtWeight_', 'uccc_seek_b2.aspx?;;;1=0', '95%', '60%']
			);

			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
				q_gt('spec', '1=1 ', 0, 0, 0, "bbsspec");
				q_gt('color', '1=1 ', 0, 0, 0, "bbscolor");
				q_gt('class', '1=1 ', 0, 0, 0, "bbsclass");
			});

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(1);
			}

			function mainPost() {
				bbmNum = [['txtTranmoney', 15, 0, 1]];
				bbsNum = [['txtMount', 15, q_getPara('rc2.mountPrecision'), 1],['txtWeight', 15, q_getPara('rc2.weightPrecision'), 1], ['txtLengthb', 15, 2, 1]];
				q_getFormat();
				bbmMask = [['txtDatea', r_picd]];
				q_mask(bbmMask);
				q_cmbParse("cmbTypea", q_getPara('cng.typea'));
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				//q_cmbParse("combUcolor", q_getPara('rc2s_vu.typea'),'s');
				q_cmbParse("combProduct", q_getPara('rc2s_vu.product'),'s');
				
				$('#txtCardealno').change(function(){
					//取得車號下拉式選單
					var thisVal = $(this).val();
					var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
					q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
				});
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
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
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
			}

			function btnOk() {
				t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')], ['txtDatea', q_getMsg('lblDatea')]]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
				
				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_cng') + $('#txtDatea').val(), '/', ''));
				else
					wrServer(s1);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;
				q_box('cng_vu_s.aspx', q_name + '_s', "500px", "330px", q_getMsg("popSeek"));
			}

			function bbsAssign() {
				for (var i = 0; i < q_bbsCount; i++) {
					if (!$('#btnMinus_' + i).hasClass('isAssign')) {
						$('#txtMount_' + i).click(function() {
							sum();
						});
						$('#combUcolor_' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtUcolor_'+b_seq).val($('#combUcolor_'+b_seq).find("option:selected").text());
						});
						$('#txtSize_' + i).change(function() {
							 if ($(this).val().substr(0, 1) != '#')
                        		$(this).val('#' + $(this).val());
						});
						$('#combSpec_' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtSpec_'+b_seq).val($('#combSpec_'+b_seq).find("option:selected").text());
						});
						$('#combClass_' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtClass_'+b_seq).val($('#combClass_'+b_seq).find("option:selected").text());
						});
						
						$('#combProduct_' +i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtProduct_'+b_seq).val($('#combProduct_'+b_seq).find("option:selected").text());
						});
					}
				}
				_bbsAssign();
				$('#lblNoq_s').text('項序');
				$('#lblUno_s').text('批號');
				$('#lblProductno_s').text('品號');
				$('#lblProduct_s').text('品名');
				$('#lblUcolor_s').text('類別');
				$('#lblSpec_s').text('材質');
				$('#lblSize_s').text('號數');
				$('#lblLengthb_s').text('米數');
				$('#lblClass_s').text('廠牌');
				$('#lblUnit_s').text('單位');
				$('#lblMount_s').text('數量(件)');
				$('#lblWeight_s').text('重量(KG)');
				$('#lblMemo_s').text('備註');
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
				//取得車號下拉式選單
				var thisVal = $('#txtCardealno').val();
				var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
				q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
			}

			function btnPrint() {
				q_box('z_cngp_vu.aspx' + "?;;;noa=" + trim($('#txtNoa').val()) + ";" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['productno']) {
					as[bbsKey[1]] = '';
					return;
				}

				q_nowf();
				as['datea'] = abbm2['datea'];
				as['tggno'] = abbm2['tggno'];
				as['typea'] = abbm2['typea'];
				as['storeno'] = abbm2['storeno'];
				as['storeinno'] = abbm2['storeinno'];
				return true;
			}

			function refresh(recno) {
				_refresh(recno);
				$('#lblStore').css('display','inline');
				$('#lblStorein').css('display','inline');
				$('#lblStorek').css('display', 'none');
				$('#lblStoreink').css('display', 'none');
			}

			function HiddenTreat(returnType){
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
			}

			function btnMinus(id) {
				_btnMinus(id);
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

			function sum() {
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
				width: 10%;
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
			.tbbm select {
				font-size: medium;
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
			.txt.c4 {
				width: 18%;
				float: left;
			}
			.txt.c5 {
				width: 80%;
				float: left;
			}
			.txt.c6 {
				width: 49%;
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
			input[type="text"], input[type="button"] {
				font-size: medium;
			}
			.dbbs {
				width: 100%;
			}
			.dbbs .tbbs {
				margin: 0;
				padding: 2px;
				border: 2px lightgrey double;
				border-spacing: 1px;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				background: lightgrey;
				width: 100%;
			}
			.dbbs .tbbs tr {
				height: 35px;
			}
			.dbbs .tbbs tr td {
				text-align: center;
				border: 2px lightgrey double;
			}
			.dbbs .tbbs select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				font-size: medium;
			}
		</style>
	</head>
	<body>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' style="width: 100%;">
			<div class="dview" id="dview" style="float: left; width:500px;" >
				<table class="tview" id="tview" border="1" cellpadding='2' cellspacing='0' style="background-color: #FFFF66;">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:15%"><a id='vewDatea'> </a></td>
						<td align="center" style="width:25%"><a id='vewStore'> </a></td>
						<td align="center" style="width:25%"><a id='vewStorein'> </a></td>
						<td align="center" style="width:25%"><a id='vewTgg'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=' '/></td>
						<td align="center" id='datea'>~datea</td>
						<td align="center" id='store,8'>~store,8</td>
						<td align="center" id='storein,8'>~storein,8</td>
						<td align="center" id='tgg,8'>~tgg,8</td>
					</tr>
				</table>
			</div>
			<div class='dbbm' style="width: 760px;float:left">
				<table class="tbbm" id="tbbm" border="0" cellpadding='2' cellspacing='0'>
					<tr>
						<td><span> </span><a id="lblType" class="lbl" > </a></td>
						<td><select id="cmbTypea" class="txt c1"> </select></td>
						<td><span> </span><a id="lblDatea" class="lbl" > </a></td>
						<td><input id="txtDatea" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblNoa" class="lbl" > </a></td>
						<td><input id="txtNoa" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td>
							<span> </span><a id="lblStore" class="lbl btn"> </a>
							<a id="lblStorek" class="lbl btn" style="display: none"> </a>
						</td>
						<td><input id="txtStoreno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtStore" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblStorein" class="lbl btn"> </a>
							<a id="lblStoreink" class="lbl btn" style="display: none"> </a>
						</td>
						<td><input id="txtStoreinno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtStorein" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblTgg" class="lbl btn"> </a></td>
						<td><input id="txtTggno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtTgg" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblTrantype" class="lbl" > </a></td>
						<td><select id="cmbTrantype" class="txt c1"> </select></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCardeal" class="lbl btn"> </a></td>
						<td><input id="txtCardealno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtCardeal" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblCarno" class="lbl" > </a></td>
						<td>
							<input id="txtCarno" type="text" class="txt" style="width:75%;"/>
							<select id="combCarno" style="width: 20%;"> </select>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblTranstart" class="lbl btn" > </a></td>
						<td ><input id="txtTranstartno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtTranstart" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblTranstyle" class="lbl" > </a></td>
						<td><select id="cmbTranstyle" style="width: 100%;"> </select></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblPost" class="lbl btn" > </a></td>
						<td ><input id="txtPost" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtAddr" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblTranmoney" class="lbl" > </a></td>
						<td><input id="txtTranmoney" type="text" class="txt c1 num"/></td>
						
					</tr>
					<tr>
						<td><span> </span><a id="lblSssno" class="lbl btn"> </a></td>
						<td><input id="txtSssno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtNamea" type="text" class="txt c1"/></td>
						<!--<td><span> </span><a id="lblPrice" class="lbl" > </a></td>
						<td><input id="txtPrice" type="text" class="txt c1 num"/></td>-->
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl"> </a></td>
						<td colspan='5'><textarea id="txtMemo" cols="10" rows="5" style="width: 99%;height: 50px;"> </textarea>
							<input id="txtWorkkno" type="hidden" /><input id="txtWorklno" type="hidden" />
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblWorker" class="lbl"> </a></td>
						<td><input id="txtWorker" type="text" class="txt c1"/></td>
						<td><input id="txtWorker2" type="text" class="txt c1"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' style="width: 100%;"><!--1650px-->
			<table id="tbbs" class='tbbs' border="1" cellpadding='2' cellspacing='1' >
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:1%;"><input class="btn" id="btnPlus" type="button" value='＋' style="font-weight: bold;" /></td>
					<td align="center" style="width:55px;"><a id='lblNoq_s'> </a></td>
					<td align="center" style="width:200px;"><a id='lblUno_s'> </a></td>
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
					<td align="center" style="width:200px;"><a id='lblMemo_s'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td><input class="btn" id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" /></td>
					<td><input id="txtNoq.*" type="text" class="txt c1"/></td>
					<td><input id="txtUno.*" type="text" class="txt c1"/></td>
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
					<td><input id="txtMemo.*" type="text" class="txt c1"/></td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>