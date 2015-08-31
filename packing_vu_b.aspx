<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
		    var q_name = 'packing', t_bbsTag = 'tbbs', t_content = " ", afilter = [], bbsKey = [], t_count = 0, as, brwCount2 = 10;
		    var t_sqlname = 'packing_load'; t_postname = q_name;
		    var isBott = false;
		    var afield, t_htm;
		    var i, s1;
		    var q_readonly = [];
		    var q_readonlys = [];
		    var bbmNum = [];
		    var bbsNum = [['txtMount', 15, 2, 1],['txtWeight', 15, 2, 1]];
		    var bbmMask = [];
		    var bbsMask = [];
            aPop = new Array( );
		    $(document).ready(function () {
		        bbmKey = [];
		        bbsKey = ['noa', 'noq'];
		        if (location.href.indexOf('?') < 0)   // debug
		        {
		            location.href = location.href + "?;;;noa='0015'";
		            return;
		        }
		        if (!q_paraChk())
		            return;
		
		        main();
		    });            /// end ready
		
		    function main() {
		        if (dataErr) {
		            dataErr = false;
		            return;
		        }
		        mainBrow(6, t_content, t_sqlname, t_postname,r_accy);
		
		    }
		    
		    function mainPost() {
				q_getFormat();
				bbsMask = [];
		        q_mask(bbsMask);
			}
		
		    function bbsAssign() {
		    		for(var j = 0; j < q_bbsCount; j++) {
		            	
					}
		        _bbsAssign();
		        for(var j = 0; j < q_bbsCount; j++) {
		    		$('#lblNo_' + j).text(j + 1);
				}
				$('#lblNo_s').text('');
				$('#lblUno_s').text('批號');
				$('#lblMount_s').text('數量');
				$('#lblWeight_s').text('重量');
				$('#lblMemo_s').text('備註');
		    }
		    
		    function q_boxClose(s2) { ///   q_boxClose 2/4 
				var ret;
				switch (b_pop) { 
					
				}
				b_pop = '';
			}
		
		    function btnOk() {
		        t_key = q_getHref();
		        _btnOk(t_key[1], bbsKey[0], bbsKey[1], '', 2);  // (key_value, bbmKey[0], bbsKey[1], '', 2);
		    }
		
		    function bbsSave(as) {
		        if (!as['uno']) {  // Dont Save Condition
		           as[bbsKey[0]] = '';   /// noa  empty --> dont save
            	return;
        		}
        		q_getId2('', as);  // write keys to as
        		return true;
		    }
		
		    function btnModi() {
		        var t_key = q_getHref();
		        if (!t_key)
		            return;
		        _btnModi(1);	        
		    }

		    function refresh() {
		        _refresh();
		    }
		    
		    var vccs;
		    function q_gtPost(t_name) {
				switch (t_name) {
					case 'vccs':
						vcces=_q_appendData("vccs", "", true);
						break;
				}  /// end switch
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
		    
		    function q_popPost(s1) {
		    	switch (s1) {
			        
		    	}
			}
		</script>
		<style type="text/css">
            td a {
                font-size: medium;
            }
            input[type="text"] {
                font-size: medium;
            }
            .txt{
            	float:left;
            	width:98%;
            }
            .num{
            	text-align: right;
            }
		</style>
	</head>
	<body>
		<div id="dbbs"  >
			<!--#include file="../inc/pop_modi.inc"-->
			<table id="tbbs" class='tbbs'  border="2"  cellpadding='2' cellspacing='1' style='width:800px;'  >
				<tr style='color:white; background:#003366;' >
					<td align="center" style="width:32px;"><input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  /></td>
					<td align="center" style="width:40px;"><a id='lblNo_s'> </a></td>
					<!--<td align="center" style="width:160px;"><a id='lblUno_s'> </a></td>-->
					<td align="center" style="width:120px;"><a id='lblMount_s'> </a></td>
					<td align="center" style="width:120px;"><a id='lblWeight_s'> </a></td>
					<td align="center"><a id='lblMemo_s'> </a></td>
				</tr>
				<tr  style='background:#cad3ff;'>
					<td align="center">
						<input class="btn"  id="btnMinus.*" type="button" value='-' style="font-weight: bold; "  />
						<input class="txt c1"  id="txtNoa.*" type="hidden"  />
                    	<input id="txtNoq.*" type="hidden" />
					</td>
					<td align="center"><a id='lblNo.*'> </a></td>
					<!--<td><input class="txt" id="txtUno.*" type="text" /></td>-->
					<td><input class="txt num" id="txtMount.*" type="text" /></td>
					<td><input class="txt num" id="txtWeight.*" type="text" /></td>
					<td><input class="txt" id="txtMemo.*" type="text" /></td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>
