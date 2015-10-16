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
			var q_name = "cuc";
			aPop = new Array();
			var intervalupdate;
			var chk_cucs=[]; //儲存要加工的cucs資料
			
			$(document).ready(function() {		
				_q_boxClose();
                q_getId();
                q_gf('', q_name);
                q_gt('spec', '1=1 ', 0, 0, 0, "");
                q_gt('color', '1=1 ', 0, 0, 0, "");
				q_gt('class', '1=1 ', 0, 0, 0, "");
				q_gt('mech', '1=1 ', 0, 0, 0, "");
			});
			
			var isupdate=false; //表示更新資料
			function cucsupdata() {
				isupdate=true;
				var bbsrow=document.getElementById("cucs_table").rows.length-1;
				if(bbsrow>0){ //有資料再刷新
					var new_where='1=0';
					for(var i=0;i<bbsrow;i++){
						if(!emp($('#cucs_noa'+i).text()) && new_where.indexOf($('#cucs_noa'+i).text()+$('#cucs_noq'+i).text())==-1)
							new_where=new_where+" or (a.noa+'-'+b.noq='"+$('#cucs_noa'+i).text()+"-"+$('#cucs_noq'+i).text()+"' )";
					}
					var t_where = "where=^^ 1=1 and ("+new_where+") and isnull(b.mins,0)=0 order by b.spec,b.size,b.lengthb,b.noa,b.noq ^^";
					q_gt('cucs_vu', t_where, 0, 0, 0,'importcucs', r_accy);
					Lock();
				}
			}
			
			var t_spec='@',t_ucolor='@',t_class='@',t_mech='@';
			var bbtaddcount=2;//bbt每次新增五筆
			var isclear=false;
			var stkupdate=0;
			function q_gfPost() {
				chk_cucs=new Array();
				
				q_getFormat();
                q_langShow();
                q_popAssign();
                $('#textDatea').mask(r_picd);
                $('#textDatea').val(q_date());
                q_cur=2;
                document.title='現場加工作業';
				
				//載入案號 資料
                var t_where = "where=^^ 1=1 and isnull(b.mins,0)=0 order by b.spec,b.size,b.lengthb,b.noa,b.noq ^^";
				q_gt('cucs_vu', t_where, 0, 0, 0,'init', r_accy);
				
				q_cmbParse("combSize", ',#2,#3,#4,#5,#6,#7,#8,#9,#10,#11,#12,#13,#14,#15,#16');
				
				//庫存
				$('#btnStk').click(function() {
					//window.open("./z_ucc_vu.aspx"+ "?"+ r_userno + ";" + r_name + ";" + q_id +";;" + r_accy);
					q_box('z_ucc_vu.aspx', 'z_ucc_vu', "95%", "95%", $('#btnStk').val());
				});
				
				//匯入
                $('#btnImport').click(function(e) {
                	var t_cucno = $('#combCucno').val();
                	var t_size = $('#combSize').val();
                	if(t_cucno.length>0){
                		var t_err = q_chkEmpField([['combMechno', '機台']]);
						if (t_err.length > 0) {
				        	alert(t_err);
							return;
						}
                		
	                    var t_where = " 1=1 and isnull(b.mins,0)=0 ";
	                    t_where += q_sqlPara2("a.noa", t_cucno);
	                    t_where += q_sqlPara2("b.size", t_size);
	                    
	                    t_where="where=^^"+t_where+" order by b.spec,b.size,b.lengthb,b.noa,b.noq ^^";
	                    Lock();
	                    isupdate=false;
						q_gt('cucs_vu', t_where, 0, 0, 0,'importcucs', r_accy);
					}
                });
                
                //解除鎖定
                $('#btnCancels').click(function(e) {
                	chk_cucs=new Array();
					q_func('qtxt.query.unlockall', 'cuc_vu.txt,unlockall,'+r_userno+';'+r_name);
                });
                
                //完工 清除所有資料
                $('#btnClear').click(function(e) {
                	clearInterval(intervalupdate);
                	isclear=true;
                	//目前鎖定資料清空
                	chk_cucs=new Array();
                	$('#cuct_table .minut').each(function() {
						$(this).click();
                    });
                	//初始化cucs
                	var t_where = "where=^^ 1=1 and isnull(b.mins,0)=0 order by b.spec,b.size,b.lengthb,b.noa,b.noq^^";
					q_gt('cucs_vu', t_where, 0, 0, 0,'init', r_accy);
                });
                
                //加工
                $('#btnCub').click(function(e) {
                	var t_err = q_chkEmpField([['textDatea', '加工日'],['combMechno', '機台']]);
	                if (t_err.length > 0) {
	                    alert(t_err);
	                    return;
	                }
                	
					if(chk_cucs.length==0){
						alert('無選取加工。');
					}else{
						//先取得最新的資料再判斷是否要轉加工單
						var bbtrow=document.getElementById("cuct_table").rows.length-1;
						var hasbbtnoweight=false; //是否有表身資料 //09/04 有重量才能入庫
						//09/08沒領料仍可入庫但有資料沒重量仍不可入庫
                    	for(var j=0;j<bbtrow;j++){
                    		var ts_product=$('#textProduct_'+j).val(),ts_ucolor=$('#textUcolor_'+j).val(),ts_spec=$('#textSpec_'+j).val();
							var ts_size=$('#textSize_'+j).val(),ts_lengthb=$('#textLengthb_'+j).val(),ts_class=$('#textClass_'+j).val();
							var ts_gmount=$('#textGmount_'+j).val(),ts_gweight=dec($('#textGweight_'+j).val()),ts_avgweight=dec($('#textAvgweight_'+j).val()),ts_memo=$('#textMemo_'+j).val();
									
							//if(!emp(ts_product) || !emp(ts_ucolor) || !emp(ts_spec) || !emp(ts_size) || 
							//	!emp(ts_lengthb) || !emp(ts_class) || !emp(ts_gmount) || !emp(ts_gweight) || !emp(ts_memo)){
							if((!emp(ts_product) || !emp(ts_ucolor) || !emp(ts_spec) || !emp(ts_size) || !emp(ts_lengthb) || !emp(ts_class))
								&& ts_gweight==0 && ts_avgweight==0){
								hasbbtnoweight=true;
								break;
                    		}
                    	}
                    	var bbsrow=document.getElementById("cucs_table").rows.length-1;
                    	t_err='';
                    	for(var j=0;j<bbsrow;j++){
                    		if($('#cucs_chk'+j).prop('checked')){
                    			var t_ordeweight=dec($('#cucs_weight'+j).text());
                    			var t_ordebweight=q_sub(t_ordeweight,dec($('#cucs_eweight'+j).text()));
                    			var t_ordexweight=dec($('#textXweight_'+j).val());
                    			if(q_div(q_add(t_ordebweight,t_ordexweight),t_ordeweight)>=1.03){
                    				t_err=t_err+(t_err.length>0?'\n':'')+'案號【'+$('#cucs_noa'+j).text()+'-'+$('#cucs_noq'+j).text()+'】完工重量超過訂單重量3%，確定是否要入庫?';
                    			}
                    		}
                    	}
						
						if(hasbbtnoweight){
							alert('領料重量等於零。');
						}else{
							if(t_err.length>0){
								if(confirm(t_err)){
									var t_where = "where=^^ 1=1 and isnull(b.mins,0)=0 order by b.spec,b.size,b.lengthb,b.noa,b.noq ^^";
									q_gt('cucs_vu', t_where, 0, 0, 0,'tocub', r_accy);
									Lock();
								}
							}else{
								if(confirm("確定是否要入庫?")){//確定轉至加工單
									var t_where = "where=^^ 1=1 and isnull(b.mins,0)=0 order by b.spec,b.size,b.lengthb,b.noa,b.noq ^^";
									q_gt('cucs_vu', t_where, 0, 0, 0,'tocub', r_accy);
									Lock();
								}
							}
						}
					}
                });
                
                //--cuct內容&事件---------------------------------------
				var string = "<table id='cuct_table' style='width:1200px;word-break:break-all;'>";
				string+='<tr id="cuct_header">';
				string+='<td id="cuct_plut" align="center" style="width:40px; color:black;"><input id="btnPlut" type="button" style="font-size: medium; font-weight: bold;" value="＋"/></td>';
				string+='<td id="cuct_product" align="center" style="width:110px; color:black;">品名</td>';
				string+='<td id="cuct_ucolor" align="center" style="width:170px; color:black;">類別</td>';
				string+='<td id="cuct_spec" align="center" style="width:140px; color:black;">材質</td>';
				string+='<td id="cuct_size" align="center" style="width:80px; color:black;">號數</td>';
				string+='<td id="cuct_lengthb" align="center" style="width:80px; color:black;">米數</td>';
				string+='<td id="cuct_class" align="center" style="width:100px; color:black;">廠牌</td>';
				string+='<td id="cuct_gmount" align="center" style="width:80px; color:black;">領料件數</td>';
				string+='<td id="cuct_gweight" align="center" style="width:90px; color:black;">領料重量</td>';
				string+='<td id="cuct_avgweight" align="center" style="width:90px; color:black;">均重</td>';
				string+='<td id="cuct_memo" align="center" style="width:220px; color:black;">備註&nbsp;&nbsp;<input id="btnCubt" type="button" style="font-size: medium; font-weight: bold;" value="領料"/></td>';
				string+='</tr>';
				string+='</table>';
				$('#cuct').html(string);
				
                //事件    
				$('#btnPlut').click(function() {
					var now_count=document.getElementById("cuct_table").rows.length-1;	
                   	t_color = ['DarkBlue','DarkRed'];
                   	var string='';
					for(var i=now_count;i<(now_count+bbtaddcount);i++){
	    				string+='<tr id="cuct_tr'+i+'">';
	    				string+='<td style="text-align: center;"><input id="btnMinut_'+i+'" class="minut" type="button" style="font-size: medium; font-weight: bold;" value="－"/></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textProduct_'+i+'"  type="text" class="txt c3" /><select id="combProduct_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textUcolor_'+i+'"  type="text" class="txt c3" /><select id="combUcolor_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textSpec_'+i+'"  type="text" class="txt c3" /><select id="combSpec_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textSize_'+i+'"  type="text" class="txt c3 sizea" style="width:50%;" /><select id="combSize_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textLengthb_'+i+'"  type="text" class="txt num c1" /></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textClass_'+i+'"  type="text" class="txt c3" /><select id="combClass_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textGmount_'+i+'"  type="text" class="txt num c1" /><a id="lblMount_'+i+'" style="display:none;"></a></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textGweight_'+i+'"  type="text" class="txt num c1" /><a id="lblWeight_'+i+'" style="display:none;"></a></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textAvgweight_'+i+'"  type="text" class="txt num c1" disabled="disabled" /></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textMemo_'+i+'"  type="text" class="txt c1" /></td>';
	    				string+='</tr>';
					}
					$('#cuct_table').append(string);
					
					//事件
					//下拉事件
					$('#cuct_table .comb').unbind("change");
                    $('#cuct_table .comb').each(function(index) {
						$(this).text(''); //清空資料
						//帶入選項值
						var n=$(this).attr('id').split('_')[1];
						var objname=$(this).attr('id').split('_')[0];
						if(objname=='combProduct'){
							q_cmbParse("combProduct_"+n, q_getPara('vccs_vu.product'));
						}
						if(objname=='combUcolor'){
							q_cmbParse("combUcolor_"+n, t_ucolor);
						}
						if(objname=='combSpec'){
							q_cmbParse("combSpec_"+n, t_spec);
						}
						if(objname=='combClass'){
							q_cmbParse("combClass_"+n, t_class);
						}
						if(objname=='combSize'){
							q_cmbParse("combSize_"+n, ',#2,#3,#4,#5,#6,#7,#8,#9,#10,#11,#12,#13,#14,#15,#16');
						}
						
						$(this).change(function() {
							var textnames=replaceAll(objname,'comb','text')
							$('#'+textnames+'_'+n).val($('#'+objname+'_'+n).find("option:selected").text());
							$('#'+objname+'_'+n).val('');
							
							//變動均價
							if(dec($('#textGmount_'+n).val())!=0 || dec($('#textGweight_'+n).val())!=0){
								var x_product=$('#textProduct_'+n).val();
								var x_spec=$('#textSpec_'+n).val();
								var x_size=$('#textSize_'+n).val();
								var x_lengthb=$('#textLengthb_'+n).val();
								var x_class=$('#textClass_'+n).val();
								var x_edate=$('#textDatea').val();
								if((x_product.length>0 || x_spec.length>0 || x_size.length>0 || x_lengthb.length>0 || x_class.length>0) && x_edate.length>0){
									x_product=emp($('#textProduct_'+n).val())?'#non':$('#textProduct_'+n).val();
									x_spec=emp($('#textSpec_'+n).val())?'#non':$('#textSpec_'+n).val();
									x_size=emp($('#textSize_'+n).val())?'#non':$('#textSize_'+n).val();
									x_lengthb=emp($('#textLengthb_'+n).val())?'#non':$('#textLengthb_'+n).val();
									x_class=emp($('#textClass_'+n).val())?'#non':$('#textClass_'+n).val();
									x_edate=emp($('#textDatea').val())?q_date():$('#textDatea').val();
									q_func('qtxt.query.getweight_'+n, 'cuc_vu.txt,stk_vu,'+x_product+';'+x_spec+';'+x_size+';'+x_lengthb+';'+x_class+';'+x_edate+';1');
								}
							}
						});
                    });
                    
                    //清空
                    $('#cuct_table .minut').unbind("click");
                    $('#cuct_table .minut').each(function(index) {
						$(this).click(function() {
							var ns=$(this).attr('id').split('_')[1];
							$('#cuct_tr'+ns+' input[type="text"]').val('');
						});
                    });
                    				
					//所有欄位text
					$('#cuct_table input[type="text"]').unbind("change");
					$('#cuct_table input[type="text"]').unbind("keyup");
					$('#cuct_table input[type="text"]').unbind("focusin");
					$('#cuct_table input[type="text"]').each(function() {
						var objname=$(this).attr('id').split('_')[0];
						var n=$(this).attr('id').split('_')[1];
						
						//只能輸入數值
						if(objname=='textLengthb' || objname=='textGmount' || objname=='textGweight'){
							$(this).keyup(function(e) {
								if(e.which>=37 && e.which<=40){return;}
								var tmp=$(this).val();
								tmp=tmp.match(/\d{1,}\.{0,1}\d{0,}/);
								$(this).val(tmp);
							});
						}
						//立刻讀均重
						if(objname=='textGmount' || objname=='textGweight'){
							$(this).focusin(function() {
								var x_product=$('#textProduct_'+n).val();
								var x_spec=$('#textSpec_'+n).val();
								var x_size=$('#textSize_'+n).val();
								var x_lengthb=$('#textLengthb_'+n).val();
								var x_class=$('#textClass_'+n).val();
								var x_edate=$('#textDatea').val();
								if((x_product.length>0 || x_spec.length>0 || x_size.length>0 || x_lengthb.length>0 || x_class.length>0) && x_edate.length>0){
									x_product=emp($('#textProduct_'+n).val())?'#non':$('#textProduct_'+n).val();
									x_spec=emp($('#textSpec_'+n).val())?'#non':$('#textSpec_'+n).val();
									x_size=emp($('#textSize_'+n).val())?'#non':$('#textSize_'+n).val();
									x_lengthb=emp($('#textLengthb_'+n).val())?'#non':$('#textLengthb_'+n).val();
									x_class=emp($('#textClass_'+n).val())?'#non':$('#textClass_'+n).val();
									x_edate=emp($('#textDatea').val())?q_date():$('#textDatea').val();
									q_func('qtxt.query.getweight_'+n, 'cuc_vu.txt,stk_vu,'+x_product+';'+x_spec+';'+x_size+';'+x_lengthb+';'+x_class+';'+x_edate+';1');
								}
							});
						}
						//變動事件
						$(this).change(function() {
							//變動均價
							if(dec($('#textGmount_'+n).val())!=0 || dec($('#textGweight_'+n).val())!=0){
								var x_product=$('#textProduct_'+n).val();
								var x_spec=$('#textSpec_'+n).val();
								var x_size=$('#textSize_'+n).val();
								var x_lengthb=$('#textLengthb_'+n).val();
								var x_class=$('#textClass_'+n).val();
								var x_edate=$('#textDatea').val();
								if((x_product.length>0 || x_spec.length>0 || x_size.length>0 || x_lengthb.length>0 || x_class.length>0) && x_edate.length>0){
									x_product=emp($('#textProduct_'+n).val())?'#non':$('#textProduct_'+n).val();
									x_spec=emp($('#textSpec_'+n).val())?'#non':$('#textSpec_'+n).val();
									x_size=emp($('#textSize_'+n).val())?'#non':$('#textSize_'+n).val();
									x_lengthb=emp($('#textLengthb_'+n).val())?'#non':$('#textLengthb_'+n).val();
									x_class=emp($('#textClass_'+n).val())?'#non':$('#textClass_'+n).val();
									x_edate=emp($('#textDatea').val())?q_date():$('#textDatea').val();
									q_func('qtxt.query.getweight_'+n, 'cuc_vu.txt,stk_vu,'+x_product+';'+x_spec+';'+x_size+';'+x_lengthb+';'+x_class+';'+x_edate+';1');
								}
							}
							//號數
							if(objname=='textSize'){
								if ($(this).val().substr(0, 1) != '#' &&!emp($(this).val()))
                        		$(this).val('#' + $(this).val());
							}
						});
						
					});
					
					//移動下一格
					var SeekF= new Array();
					$('input:text,select').each(function() {
						if($(this).attr('disabled')!='disabled')
							SeekF.push($(this).attr('id'));
					});
					$('input:text,select').each(function() {
						$(this).bind('keydown', function(event) {
							if( event.which == 13 || event.which == 40) {
								$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).focus();
								$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).select();
							}
						});
					});
				});
				
				$('#btnCubt').click(function() {
					var t_err = q_chkEmpField([['textDatea', '加工日'],['combMechno', '機台']]);
	                if (t_err.length > 0) {
	                    alert(t_err);
	                    return;
	                }
	                //判斷庫存
	                var bbtrow=document.getElementById("cuct_table").rows.length-1;
	                var has_get=false;
	                for(var j=0;j<bbtrow;j++){
		                if(dec($('#textGmount_'+j).val())!=0 || dec($('#textGweight_'+j).val())!=0){
							var x_product=$('#textProduct_'+j).val();
							var x_spec=$('#textSpec_'+j).val();
							var x_size=$('#textSize_'+j).val();
							var x_lengthb=$('#textLengthb_'+j).val();
							var x_class=$('#textClass_'+j).val();
							var x_edate=$('#textDatea').val();
							if((x_product.length>0 || x_spec.length>0 || x_size.length>0 || x_lengthb.length>0 || x_class.length>0) && x_edate.length>0){
								x_product=emp($('#textProduct_'+j).val())?'#non':$('#textProduct_'+j).val();
								x_spec=emp($('#textSpec_'+j).val())?'#non':$('#textSpec_'+j).val();
								x_size=emp($('#textSize_'+j).val())?'#non':$('#textSize_'+j).val();
								x_lengthb=emp($('#textLengthb_'+j).val())?'#non':$('#textLengthb_'+j).val();
								x_class=emp($('#textClass_'+j).val())?'#non':$('#textClass_'+j).val();
								x_edate=emp($('#textDatea').val())?q_date():$('#textDatea').val();
								q_func('qtxt.query.cuctstkupdate_'+j, 'cuc_vu.txt,stk_vu,'+x_product+';'+x_spec+';'+x_size+';'+x_lengthb+';'+x_class+';'+x_edate+';1');
								stkupdate++;
							}
							has_get=true;
						}
					}
					if(!has_get)
						alert('領料重量等於0!!');
				});
				
				$('#btnPlut').click();
				
				//浮動表頭
				var string = "<div id='cuct_float' style='position:absolute;display:block;left:0px; top:0px;'>";
				string+="<table id='cuct_table2' style='width:1200px;border-bottom: none;'>";
				string+='<tr id="cuct_header">';
				string+='<td id="cuct_plut" align="center" style="width:40px; color:black;"><input id="btnPlut2" type="button" style="font-size: medium; font-weight: bold;" value="＋"/></td>';
				string+='<td id="cuct_product" align="center" style="width:110px; color:black;">品名</td>';
				string+='<td id="cuct_ucolor" align="center" style="width:170px; color:black;">類別</td>';
				string+='<td id="cuct_spec" align="center" style="width:140px; color:black;">材質</td>';
				string+='<td id="cuct_size" align="center" style="width:80px; color:black;">號數</td>';
				string+='<td id="cuct_lengthb" align="center" style="width:80px; color:black;">米數</td>';
				string+='<td id="cuct_class" align="center" style="width:100px; color:black;">廠牌</td>';
				string+='<td id="cuct_gmount" align="center" style="width:80px; color:black;">領料件數</td>';
				string+='<td id="cuct_gweight" align="center" style="width:90px; color:black;">領料重量</td>';
				string+='<td id="cuct_avgweight" align="center" style="width:90px; color:black;">均重</td>';
				string+='<td id="cuct_memo" align="center" style="width:220px; color:black;">備註&nbsp;&nbsp;<input id="btnCubt2" type="button" style="font-size: medium; font-weight: bold;" value="領料"/><input type="button" id="btnCub_nouno" value="條碼領料" style="width:80px;font-size: medium; font-weight: bold"/></td>';
				string+='</tr>';
				string+='</table>';
				$('#cuct').append(string);
				
				$('#btnPlut2').click(function() {
					$('#btnPlut').click();
				});
				$('#btnCubt2').click(function() {
					$('#btnCubt').click();
				});
				
				$('#btnCub_nouno').click(function(e) {
					$('#div_nouno').css('top',($('#btnCub_nouno').offset().top-$('#div_nouno').height())+'px');
					$('#div_nouno').css('left',($('#btnCub_nouno').offset().left-$('#div_nouno').width())+'px');
					$('#div_nouno').show();
				});
				$('#textNouno').click(function() {
                	q_msg($(this),'多批號領料請用,隔開');
				});
				$('#btnOk_div_nouno').click(function() {
					var t_err = q_chkEmpField([['combMechno', '機台']]);
	                if (t_err.length > 0) {
	                    alert(t_err);
	                    return;
	                }
	                
					var t_nouno=$.trim($('#textNouno').val());
					if(t_nouno.length>0){
						t_nouno=t_nouno.split(',');
						var t_where="";
						for (var i=0;i<t_nouno.length;i++){
							t_where=t_where+(t_where.length>0?" or ":"")+"uno='"+t_nouno[i]+"'";
						}
						var t_where = "where=^^ ("+t_where+") ^^";
						q_gt('view_cubs', t_where, 0, 0, 0, "nouno_getuno", r_accy);
					}
				});
				$('#btnClose_div_nouno').click(function() {
					$('#textNouno').val('');
                	$('#div_nouno').hide();
				});
				
				//設定滾動條移動時浮動表頭與div的距離
				$('#cuct').scroll(function(){
					$('#cuct_float').css('top',$(this).scrollTop()+"px")
				});
				
				//--cucu內容&事件---------------------------------------
				var string = "<table id='cucu_table' style='width:1200px;word-break:break-all;'>";
				string+='<tr id="cucu_header">';
				string+='<td id="cucu_plut" align="center" style="width:40px; color:black;"><input id="btnPluu" type="button" style="font-size: medium; font-weight: bold;" value="＋"/></td>';
				string+='<td id="cucu_product" align="center" style="width:110px; color:black;">品名</td>';
				string+='<td id="cucu_ucolor" align="center" style="width:170px; color:black;">類別</td>';
				string+='<td id="cucu_spec" align="center" style="width:140px; color:black;">材質</td>';
				string+='<td id="cucu_size" align="center" style="width:80px; color:black;">號數</td>';
				string+='<td id="cucu_lengthb" align="center" style="width:80px; color:black;">米數</td>';
				string+='<td id="cucu_class" align="center" style="width:100px; color:black;">廠牌</td>';
				string+='<td id="cucu_mount" align="center" style="width:80px; color:black;">件數</td>';
				string+='<td id="cucu_hmount" align="center" style="width:90px; color:black;">支數</td>';
				string+='<td id="cucu_weight" align="center" style="width:90px; color:black;">重量</td>';
				string+='<td id="cucu_memo" align="center" style="width:220px; color:black;">備註&nbsp;&nbsp;<input id="btnCubs" type="button" style="font-size: medium; font-weight: bold;" value="入庫"/></td>';
				string+='</tr>';
				string+='</table>';
				$('#cucu').html(string);
				
                //事件    
				$('#btnPluu').click(function() {
					var now_count=document.getElementById("cucu_table").rows.length-1;	
                   	t_color = ['DarkBlue','DarkRed'];
                   	var string='';
					for(var i=now_count;i<(now_count+bbtaddcount);i++){
	    				string+='<tr id="cucu_tr'+i+'">';
	    				string+='<td style="text-align: center;"><input id="btnMinut__'+i+'" class="minut" type="button" style="font-size: medium; font-weight: bold;" value="－"/></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textProduct__'+i+'"  type="text" class="txt c3" /><select id="combProduct__'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textUcolor__'+i+'"  type="text" class="txt c3" /><select id="combUcolor__'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textSpec__'+i+'"  type="text" class="txt c3" /><select id="combSpec__'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textSize__'+i+'"  type="text" class="txt c3 sizea" style="width:50%;" /><select id="combSize__'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textLengthb__'+i+'"  type="text" class="txt num c1" /></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textClass__'+i+'"  type="text" class="txt c3" /><select id="combClass__'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textImount__'+i+'"  type="text" class="txt num c1" /></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textIhmount__'+i+'"  type="text" class="txt num c1" /></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textIweight__'+i+'"  type="text" class="txt num c1" /></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textMemo__'+i+'"  type="text" class="txt c1" /></td>';
	    				string+='</tr>';
					}
					$('#cucu_table').append(string);
					
					//事件
					//下拉事件
					$('#cucu_table .comb').unbind("change");
                    $('#cucu_table .comb').each(function(index) {
						$(this).text(''); //清空資料
						//帶入選項值
						var n=$(this).attr('id').split('__')[1];
						var objname=$(this).attr('id').split('__')[0];
						if(objname=='combProduct'){
							q_cmbParse("combProduct__"+n, q_getPara('vccs_vu.product'));
						}
						if(objname=='combUcolor'){
							q_cmbParse("combUcolor__"+n, t_ucolor);
						}
						if(objname=='combSpec'){
							q_cmbParse("combSpec__"+n, t_spec);
						}
						if(objname=='combClass'){
							q_cmbParse("combClass__"+n, t_class);
						}
						if(objname=='combSize'){
							q_cmbParse("combSize__"+n, ',#2,#3,#4,#5,#6,#7,#8,#9,#10,#11,#12,#13,#14,#15,#16');
						}
						
						$(this).change(function() {
							var textnames=replaceAll(objname,'comb','text')
							$('#'+textnames+'__'+n).val($('#'+objname+'__'+n).find("option:selected").text());
							$('#'+objname+'__'+n).val('');
						});
                    });
                    
                    //清空
                    $('#cucu_table .minut').unbind("click");
                    $('#cucu_table .minut').each(function(index) {
						$(this).click(function() {
							var ns=$(this).attr('id').split('__')[1];
							$('#cucu_tr'+ns+' input[type="text"]').val('');
						});
                    });
                    				
					//所有欄位text
					$('#cucu_table input[type="text"]').unbind("change");
					$('#cucu_table input[type="text"]').unbind("keyup");
					$('#cucu_table input[type="text"]').unbind("focusin");
					$('#cucu_table input[type="text"]').each(function() {
						var objname=$(this).attr('id').split('__')[0];
						var n=$(this).attr('id').split('__')[1];
						
						//只能輸入數值
						if(objname=='textLengthb' || objname=='textImount' || objname=='textIhmount' || objname=='textIweight'){
							$(this).keyup(function(e) {
								if(e.which>=37 && e.which<=40){return;}
								var tmp=$(this).val();
								tmp=tmp.match(/\d{1,}\.{0,1}\d{0,}/);
								$(this).val(tmp);
							});
						}
						//變動事件
						$(this).change(function() {
							//號數
							if(objname=='textSize'){
								if ($(this).val().substr(0, 1) != '#' &&!emp($(this).val()))
                        		$(this).val('#' + $(this).val());
							}
						});
						
					});
					
					//移動下一格
					var SeekF= new Array();
					$('input:text,select').each(function() {
						if($(this).attr('disabled')!='disabled')
							SeekF.push($(this).attr('id'));
					});
					$('input:text,select').each(function() {
						$(this).bind('keydown', function(event) {
							if( event.which == 13 || event.which == 40) {
								$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).focus();
								$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).select();
							}
						});
					});
				});
				
				$('#btnCubs').click(function() {
					var t_err = q_chkEmpField([['textDatea', '加工日'],['combMechno', '機台']]);
	                if (t_err.length > 0) {
	                    alert(t_err);
	                    return;
	                }
	                //入庫
	                var ts_bbu='';
	                var bburow=document.getElementById("cucu_table").rows.length-1;
					var hasbbu=false;
					var t_datea=emp($('#textDatea').val())?'#non':$('#textDatea').val();
	                var t_mechno=emp($('#combMechno').val())?'#non':$('#combMechno').val();
	                var t_memo=emp($('#textMemo').val())?'#non':$('#textMemo').val();
					for(var j=0;j<bburow;j++){
	                    var ts_product=$('#textProduct__'+j).val();
		                var ts_ucolor=$('#textUcolor__'+j).val();
						var ts_spec=$('#textSpec__'+j).val();
						var ts_size=$('#textSize__'+j).val();
						var ts_lengthb=$('#textLengthb__'+j).val();
						var ts_class=$('#textClass__'+j).val();
						var ts_imount=$('#textImount__'+j).val();
						var ts_ihmount=$('#textIhmount__'+j).val();
						var ts_iweight=$('#textIweight__'+j).val();
						var ts_memo=$('#textMemo__'+j).val();
																
						if(!emp(ts_product) || !emp(ts_ucolor) || !emp(ts_spec) || !emp(ts_size) || !emp(ts_lengthb) || !emp(ts_class)){
							hasbbu=true; //有資料
							if (dec(ts_imount)>0 && dec(ts_iweight)>0){ //件數重量>0
								ts_bbu=ts_bbu
								+ts_product+"^@^"
								+ts_ucolor+"^@^"
								+ts_spec+"^@^"
								+ts_size+"^@^"
								+dec(ts_lengthb)+"^@^"
								+ts_class+"^@^"
								+dec(ts_imount)+"^@^"
								+dec(ts_ihmount)+"^@^"
								+dec(ts_iweight)+"^@^"
								+ts_memo+"^@^"
								+"^#^";
		                   	}
						}
					}
					if(!hasbbu){
						alert('無入庫資料');
					}else if(ts_bbu.length==0){
	                   	alert('入庫件數或重量等於零。');
					}else{
	                   	if(confirm("確認要入庫?")){
	                   		Lock();
		                   	q_func('qtxt.query.cucutocubs', 'cuc_vu.txt,cucutocubs,'
							+r_accy+';'+t_datea+';'+t_mechno+';'+t_memo+';'+r_userno+';'+r_name+';'+ts_bbu);
						}
					}
				});
				
				$('#btnPluu').click();
				
				//浮動表頭
				var string = "<div id='cucu_float' style='position:absolute;display:block;left:0px; top:0px;'>";
				string+="<table id='cucu_table2' style='width:1200px;border-bottom: none;'>";
				string+='<tr id="cucu_header">';
				string+='<td id="cucu_plut" align="center" style="width:40px; color:black;"><input id="btnPluu2" type="button" style="font-size: medium; font-weight: bold;" value="＋"/></td>';
				string+='<td id="cucu_product" align="center" style="width:110px; color:black;">品名</td>';
				string+='<td id="cucu_ucolor" align="center" style="width:170px; color:black;">類別</td>';
				string+='<td id="cucu_spec" align="center" style="width:140px; color:black;">材質</td>';
				string+='<td id="cucu_size" align="center" style="width:80px; color:black;">號數</td>';
				string+='<td id="cucu_lengthb" align="center" style="width:80px; color:black;">米數</td>';
				string+='<td id="cucu_class" align="center" style="width:100px; color:black;">廠牌</td>';
				string+='<td id="cucu_mount" align="center" style="width:80px; color:black;">件數</td>';
				string+='<td id="cucu_hmount" align="center" style="width:90px; color:black;">支數</td>';
				string+='<td id="cucu_weight" align="center" style="width:90px; color:black;">重量</td>';
				string+='<td id="cucu_memo" align="center" style="width:220px; color:black;">備註&nbsp;&nbsp;<input id="btnCubs2" type="button" style="font-size: medium; font-weight: bold;" value="入庫"/></td>';
				string+='</tr>';
				string+='</table>';
				$('#cucu').append(string);
				
				$('#btnPluu2').click(function() {
					$('#btnPluu').click();
				});
				$('#btnCubs2').click(function() {
					$('#btnCubs').click();
				});
				
				//設定滾動條移動時浮動表頭與div的距離
				$('#cucu').scroll(function(){
					$('#cucu_float').css('top',$(this).scrollTop()+"px")
				});
				
				//---------------------------------------------------------------------------------------------------
				//移動下一格
				var SeekF= new Array();
				$('input:text,select').each(function() {
					if($(this).attr('disabled')!='disabled')
						SeekF.push($(this).attr('id'));
				});
				$('input:text,select').each(function() {
					$(this).bind('keydown', function(event) {
						if( event.which == 13 || event.which == 40) {
							$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).focus();
							$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).select();
						}
					});
				});
            }
            
            function q_gtPost(t_name) {
				switch (t_name) {
					case 'init':
						//載入bbs表頭
						var string = "<table id='cucs_table' style='width:1230px;word-break:break-all;'>";
						string+='<tr id="cucs_header">';
						string+='<td id="cucs_chk" align="center" style="width:30px; color:black;">鎖</td>';
						string+='<td id="cucs_cubno" align="center" style="width:20px; color:black;display:none;">鎖定人</td>'
						string+='<td id="cucs_noa" align="center" style="width:70px; color:black;">案號</td>'
						string+='<td id="cucs_noq" align="center" style="width:30px; color:black;">案序</td>'
						string+='<td id="cucs_odatea" title="預交日" align="center" style="width:80px; color:black;">預交日</td>';
						string+='<td id="cucs_ucolor" title="類別" align="center" style="width:120px; color:black;">類別</td>';
						string+='<td id="cucs_product" title="品名" align="center" style="width:70px; color:black;">品名</td>';
						string+='<td id="cucs_spec" title="材質" align="center" style="width:80px; color:black;">材質</td>';
						string+='<td id="cucs_size" title="號數" align="center" style="width:50px; color:black;">號數</td>';
						string+='<td id="cucs_lengthb" title="米數" align="center" style="width:50px; color:black;">米數</td>';
						string+='<td id="cucs_mount" title="訂單件數" align="center" style="width:50px; color:black;" class="co1">訂單件數</td>';
						string+='<td id="cucs_1mount" title="訂單支數" align="center" style="width:50px; color:black;" class="co1">訂單支數</td>';
						string+='<td id="cucs_weight" title="訂單重量" align="center" style="width:50px; color:black;" class="co1">訂單重量</td>';
						string+='<td id="cucs_emount" title="未完工件數" align="center" style="width:60px; color:black;" class="co2">未完工件數</td>';
						string+='<td id="cucs_ehmount" title="未完工支數" align="center" style="width:60px; color:black;" class="co2">未完工支數</td>';
						string+='<td id="cucs_eweight" title="未完工重量" align="center" style="width:60px; color:black;" class="co2">未完工重量</td>';
						string+='<td id="cucs_xmount" title="件數" align="center" style="width:50px; color:black;" class="co3">件數</td>';
						string+='<td id="cucs_xcount" title="支數" align="center" style="width:50px; color:black;" class="co3">支數</td>';
						string+='<td id="cucs_xweight" title="重量" align="center" style="width:60px; color:black;" class="co3">重量</td>';
						string+='<td id="cucs_memo" title="備註" align="center" style="width:100px; color:black;">備註</td>';
						string+='<td id="cucs_custno" title="客戶編號" align="center" style="width:75px; color:black;display:none;">客戶編號</td>';
						string+='<td id="cucs_cust" title="客戶名稱" align="center" style="width:75px; color:black;">客戶名稱</td>';
						string+='<td id="cucs_ordeno" title="訂單號碼" align="center" style="width:90px; color:black;display:none;">訂單號碼</td>';
						string+='<td id="cucs_no2" title="訂單序號" align="center" style="width:90px; color:black;display:none;">訂單序號</td>';
						string+='<td id="cucs_mins" align="center" style="width:30px; color:black;">完工</td>';
						string+='</tr>';
						string+='</table>';
						$('#cucs').html(string);
						
						//浮動表頭
						var string = "<div id='cucs_float' style='position:absolute;display:block;left:0px; top:0px;'>";
						string+="<table id='cucs_table2' style='width:1230px;border-bottom: none;'>";
						string+='<tr id="cucs_header">';
						string+='<td id="cucs_chk" align="center" style="width:30px; color:black;">鎖</td>';
						string+='<td id="cucs_cubno" align="center" style="width:20px; color:black;display:none;">鎖定人</td>'
						string+='<td id="cucs_noa" align="center" style="width:70px; color:black;">案號</td>'
						string+='<td id="cucs_noq" align="center" style="width:30px; color:black;">案序</td>'
						string+='<td id="cucs_odatea" title="預交日" align="center" style="width:80px; color:black;">預交日</td>';
						string+='<td id="cucs_ucolor" title="類別" align="center" style="width:120px; color:black;">類別</td>';
						string+='<td id="cucs_product" title="品名" align="center" style="width:70px; color:black;">品名</td>';
						string+='<td id="cucs_spec" title="材質" align="center" style="width:80px; color:black;">材質</td>';
						string+='<td id="cucs_size" title="號數" align="center" style="width:50px; color:black;">號數</td>';
						string+='<td id="cucs_lengthb" title="米數" align="center" style="width:50px; color:black;">米數</td>';
						string+='<td id="cucs_mount" title="訂單件數" align="center" style="width:50px; color:black;" class="co1" >訂單件數</td>';
						string+='<td id="cucs_1mount" title="訂單支數" align="center" style="width:50px; color:black;" class="co1">訂單支數</td>';
						string+='<td id="cucs_weight" title="訂單重量" align="center" style="width:50px; color:black;" class="co1">訂單重量</td>';
						string+='<td id="cucs_emount" title="未完工件數" align="center" style="width:60px; color:black;" class="co2">未完工件數</td>';
						string+='<td id="cucs_ehmount" title="未完工支數" align="center" style="width:60px; color:black;" class="co2">未完工支數</td>';
						string+='<td id="cucs_eweight" title="未完工重量" align="center" style="width:60px; color:black;" class="co2">未完工重量</td>';
						string+='<td id="cucs_xmount" title="件數" align="center" style="width:50px; color:black;" class="co3">件數</td>';
						string+='<td id="cucs_xcount" title="支數" align="center" style="width:50px; color:black;" class="co3">支數</td>';
						string+='<td id="cucs_xweight" title="重量" align="center" style="width:60px; color:black;" class="co3">重量</td>';
						string+='<td id="cucs_memo" title="備註" align="center" style="width:100px; color:black;">備註</td>';
						string+='<td id="cucs_custno" title="客戶編號" align="center" style="width:75px; color:black;display:none;">客戶編號</td>';
						string+='<td id="cucs_cust" title="客戶名稱" align="center" style="width:75px; color:black;">客戶名稱</td>';
						string+='<td id="cucs_ordeno" title="訂單號碼" align="center" style="width:90px; color:black;display:none;">訂單號碼</td>';
						string+='<td id="cucs_no2" title="訂單序號" align="center" style="width:90px; color:black;display:none;">訂單序號</td>';
						string+='<td id="cucs_mins" align="center" style="width:30px; color:black;">完工</td>';
						string+='</tr>';
						string+='</table>';
						$('#cucs_float').remove();
						$('#cucs').append(string);
						
						//設定滾動條移動時浮動表頭與div的距離
						$('#cucs').scroll(function(){
							$('#cucs_float').css('top',$(this).scrollTop()+"px")
						});
					
						var as = _q_appendData("view_cuc", "", true);
                        var comb_noa='@';
                        
                        for(var i=0;i<as.length;i++){
                        	if(comb_noa.indexOf(as[i].noa)==-1)
                        		comb_noa=comb_noa+","+as[i].noa+"@"+as[i].noa
                        }
                        $('#combCucno').text('');
                        q_cmbParse("combCucno", comb_noa);
                        
                        if(isclear){
                        	//清空該使用者的全部鎖定
							q_func('qtxt.query.unlockall', 'cuc_vu.txt,unlockall,'+r_userno+';'+r_name);
                        }
                        
                        intervalupdate=setInterval("cucsupdata()",1000*60);
                        break;
					case 'importcucs':
						//現在表身資料
						var bbsrow=document.getElementById("cucs_table").rows.length-1;
						var as = _q_appendData("view_cuc", "", true);
						var imp_cucno=''; //匯入的cucno
						/*if(as[0]!=undefined && !isupdate){ //匯入資料就先鎖單
							imp_cucno=as[0].noa;
						}*/
						//變動核取資料
						for(var i =0 ;i<as.length;i++){
                    		var cubno=as[i]['cubno'];
							if(cubno.length>0){
								//判斷是否被鎖定或解除鎖定或鎖定時間超過30分
	                    		var lock_time=cubno.split('##')[3]!=undefined?cubno.split('##')[3]:'';
								var islock=false;
								if(lock_time.length>0){
									islock=true;
									var now_time = new Date();
									lock_time = new Date(lock_time);
									var diff = now_time - lock_time;
									if(diff>1000 * 60 * 30) //超過30分表示已解除鎖定
										islock=false;
								}
								
								if(islock && cubno.split('##')[0]==r_userno){ //自己的鎖定資料
									var t_exists=false;
		                    		for(var j=0;j<chk_cucs.length;j++){
		                    			if(as[i]['noa']==chk_cucs[j]['noa'] && as[i]['noq']==chk_cucs[j]['noq']){
		                    				t_exists=true;
		                    			}
		                    		}
		                    		if(!t_exists){//當不存在時新增
		                    			chk_cucs.push({
												noa : as[i]['noa'],
												noq : as[i]['noq'],
												xmount : 0,
												xcount : 0,
												xweight : 0,
												ordeno:as[i]['ordeno'],
												no2:as[i]['no2']
										});
		                    		}
		                    	}else{//被他人鎖定資料 或鎖定時間超過30分
		                    		for(var j=0;j<chk_cucs.length;j++){
		                    			if(as[i]['noa']==chk_cucs[j]['noa'] && as[i]['noq']==chk_cucs[j]['noq']){
		                    				chk_cucs.splice(j, 1);
		                    				j--;
                        	 				break;
		                    			}
		                    		}
		                    	}
		                    }else{//無鎖定資料
		                    	for(var j=0;j<chk_cucs.length;j++){
		                    		if(as[i]['noa']==chk_cucs[j]['noa'] && as[i]['noq']==chk_cucs[j]['noq']){
		                    			chk_cucs.splice(j, 1);
		                    			j--;
                        	 			break;
		                    		}
		                    	}
		                    }
	                    }
	                    
						var table_noa='';
						if(bbsrow!=0){//表示目前有無資料 有要更新資料
							for(var j=0;j<bbsrow;j++){
								var bbsexists=false;
								for(var i =0 ;i<as.length;i++){
									if(as[i].noa==$('#cucs_noa'+j).text() && as[i].noq==$('#cucs_noq'+j).text()){
										bbsexists=true;
										//資料存在,更新表身資料
										$('#cucs_cubno'+j).text(as[i].cubno);
										$('#cucs_noa'+j).text(as[i].noa);
										$('#cucs_noq'+j).text(as[i].noq);
										$('#cucs_odatea'+j).text(as[i].odatea);
										$('#cucs_ucolor'+j).text(as[i].ucolor);
										$('#cucs_product'+j).text(as[i].product);
										$('#cucs_spec'+j).text(as[i].spec);
										$('#cucs_size'+j).text(as[i].size);
										$('#cucs_lengthb'+j).text(as[i].lengthb);
										$('#cucs_mount'+j).text(as[i].mount);
										$('#cucs_weight'+j).text(as[i].weight);
										$('#cucs_1mount'+j).text(as[i].mount1);
										$('#cucs_emount'+j).text(round(as[i].emount,3));
										$('#cucs_eweight'+j).text(round(as[i].eweight,3));
										$('#cucs_ehmount'+j).text(round(as[i].ehmount,3));
										$('#cucs_memo'+j).text(as[i].memo);
										$('#cucs_custno'+j).text(as[i].acustno);
										$('#cucs_cust'+j).text(as[i].acust.substr(0,4));
										$('#cucs_ordeno'+j).text(as[i].ordeno);
										$('#cucs_no2'+j).text(as[i].no2);
										
										//移除已存在的資料
										as.splice(i, 1);
										i--;
										break;
									}
								}
								
								if(isupdate && !bbsexists){//更新資料 bbs 一定要存在 , 不存在表示已完工或資料被刪除
									//刪除bbs 資料
									$('#cucs_tr'+j).find('td').css('background', 'lavender');
									$('#cucs_tr'+j+' .co1').css('background-color', 'antiquewhite');
		                            $('#cucs_tr'+j+' .co2').css('background-color', 'lightpink');
		                            $('#cucs_tr'+j+' .co3').css('background-color', 'lightsalmon');
									$('#cucs_chk'+j).remove();
									$('#textXmount_'+j).remove();
									$('#textXcount_'+j).remove();
									$('#textXweight_'+j).remove();
									$('#cucs_lbla'+j).text();
									$('#cucs_cubno'+j).text('');
									$('#cucs_noa'+j).text('');
									$('#cucs_noq'+j).text('');
									$('#cucs_odatea'+j).text('');
									$('#cucs_ucolor'+j).text('');
									$('#cucs_product'+j).text('');
									$('#cucs_spec'+j).text('');
									$('#cucs_size'+j).text('');
									$('#cucs_lengthb'+j).text('');
									$('#cucs_mount'+j).text('');
									$('#cucs_weight'+j).text('');
									$('#cucs_1mount'+j).text('');
									$('#cucs_emount'+j).text('');
									$('#cucs_eweight'+j).text('');
									$('#cucs_ehmount'+j).text('');
									$('#cucs_memo'+j).text('');
									$('#cucs_custno'+j).text('');
									$('#cucs_cust'+j).text('');
									$('#cucs_ordeno'+j).text('');
									$('#cucs_no2'+j).text('');
									$('#cucs_mins'+j).remove();
								}
							}
							table_noa=$('#cucs_noa'+(bbsrow-1)).text();
						}
						
						isupdate=false;
						
						t_color = ['DarkBlue','DarkRed'];
						var string='';
						for(var i=0;i<as.length;i++){
							if(table_noa!='' && table_noa!=as[i].noa){ //不同案號 空依格
								string+='<tr id="cucs_tr'+(i+bbsrow)+'">';
								string+='<td style="text-align: center;"></td>';
								string+='<td id="cucs_cubno'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_noa'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_noq'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_odatea'+(i+bbsrow)+'" style="font-size: 14px;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_ucolor'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_product'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_spec'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_size'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_lengthb'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_mount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co1"></td>';
								string+='<td id="cucs_1mount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co1"></td>';
								string+='<td id="cucs_weight'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co1"></td>';
								string+='<td id="cucs_emount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2"></td>';
								string+='<td id="cucs_ehmount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2"></td>';
								string+='<td id="cucs_eweight'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2"></td>';
								string+='<td id="cucs_xmount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co3"></td>';
								string+='<td id="cucs_xcount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co3"></td>';
								string+='<td id="cucs_xweight'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co3"></td>';
								string+='<td id="cucs_memo'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_custno'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_cust'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_ordeno'+(i+bbsrow)+'" style="display:none;font-size: 12px;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_no2'+(i+bbsrow)+'" style="display:none;font-size: 12px;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td style="text-align: center;"></td>';
								string+='</tr>';
								bbsrow++;
							}
							
							string+='<tr id="cucs_tr'+(i+bbsrow)+'">';
							string+='<td style="text-align: center;"><input id="cucs_chk'+(i+bbsrow)+'" class="cucs_chk" type="checkbox"/><a id="cucs_lbla'+(i+bbsrow)+'" ></a></td>';
							string+='<td id="cucs_cubno'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].cubno+'</td>';
							string+='<td id="cucs_noa'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].noa+'</td>';
							string+='<td id="cucs_noq'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].noq+'</td>';
							string+='<td id="cucs_odatea'+(i+bbsrow)+'" style="font-size: 14px;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].odatea+'</td>';
							string+='<td id="cucs_ucolor'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].ucolor+'</td>';
							string+='<td id="cucs_product'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].product+'</td>';
							string+='<td id="cucs_spec'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].spec+'</td>';
							string+='<td id="cucs_size'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].size+'</td>';
							string+='<td id="cucs_lengthb'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].lengthb+'</td>';
							string+='<td id="cucs_mount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co1">'+as[i].mount+'</td>';
							string+='<td id="cucs_1mount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co1">'+as[i].mount1+'</td>';
							string+='<td id="cucs_weight'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co1">'+as[i].weight+'</td>';
							string+='<td id="cucs_emount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2">'+round(as[i].emount,3)+'</td>';
							string+='<td id="cucs_ehmount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2">'+round(as[i].ehmount,3)+'</td>';
							string+='<td id="cucs_eweight'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2">'+round(as[i].eweight,3)+'</td>';
							string+='<td id="cucs_xmount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co3"><input id="textXmount_'+(i+bbsrow)+'"  type="text" class="xmount txt c1 num" disabled="disabled" /></td>';
							string+='<td id="cucs_xcount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co3"><input id="textXcount_'+(i+bbsrow)+'"  type="text" class="xcount txt c1 num" disabled="disabled"/></td>';
							string+='<td id="cucs_xweight'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co3"><input id="textXweight_'+(i+bbsrow)+'"  type="text" class="xweight txt c1 num" disabled="disabled"/></td>';
							string+='<td id="cucs_memo'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].memo+'</td>';
							string+='<td id="cucs_custno'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].acustno+'</td>';
							string+='<td id="cucs_cust'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].acust.substr(0,4)+'</td>';
							string+='<td id="cucs_ordeno'+(i+bbsrow)+'" style="display:none;font-size: 12px;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].ordeno+'</td>';
							string+='<td id="cucs_no2'+(i+bbsrow)+'" style="display:none;font-size: 12px;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].no2+'</td>';
							string+='<td style="text-align: center;"><input id="cucs_mins'+(i+bbsrow)+'" class="cucs_mins" type="checkbox"/></td>';
							string+='</tr>';
							
							table_noa=as[i].noa;
						}
						
						$('#cucs_table').append(string);
						cucs_refresh();
						
						//事件更新
						$('#cucs .cucs_chk').unbind('click');
						$('#cucs .cucs_chk').click(function(e) {
							var n=$(this).attr('id').replace('cucs_chk','')
							if($(this).prop('checked')){
								var t_err = q_chkEmpField([['combMechno', '機台']]);
				                if (t_err.length > 0) {
				                    alert(t_err);
				                    $(this).prop("checked",false).parent().parent().find('td').css('background', 'lavender');
				                    $('#cucs_tr'+n+' .co1').css('background-color', 'antiquewhite');
		                            $('#cucs_tr'+n+' .co2').css('background-color', 'lightpink');
		                            $('#cucs_tr'+n+' .co3').css('background-color', 'lightsalmon');
		                            
		                            var cucsno=$('#cucs_noa' + n).text();
									var eweight=dec($('#cucs_eweight' + n).text());
									if(cucsno!='' && eweight<=0){
										$('#cucs_tr'+n).find('td').css('background', 'darkturquoise');
									}
		                            
				                    return;
				                }
							}
							//Lock();
							var t_where="where=^^  1=1 and a.noa='"+$('#cucs_noa'+n).text()+"' and b.noq='"+$('#cucs_noq'+n).text()+"' and isnull(b.mins,0)=0 ^^";
							//判斷是否能被鎖定或解除
							if($(this).prop('checked')){
								q_gt('cucs_vu', t_where, 0, 0, 0,'getcanlock_'+n, r_accy);
							}else{
								q_gt('cucs_vu', t_where, 0, 0, 0,'getcanunlock_'+n, r_accy);
							}
						});
	                    
	                    $('#cucs .num').unbind('blur');
	                    $('#cucs .num').unbind('keyup');
	                    $('#cucs .num').each(function() {
	                    	$(this).blur(function() {
	                    		var objnamea=$(this).attr('id').split('_')[0];
		                        var n=$(this).attr('id').split('_')[1];
		                        //修改暫存資料
		                        for(var i =0 ;i<chk_cucs.length;i++){
									if(chk_cucs[i].noa==$('#cucs_noa'+n).text() && chk_cucs[i].noq==$('#cucs_noq'+n).text()){
										if(objnamea=='textXmount')
											chk_cucs[i].xmount=$('#'+objnamea+'_'+n).val();
										if(objnamea=='textXcount')
											chk_cucs[i].xcount=$('#'+objnamea+'_'+n).val();
										if(objnamea=='textXweight')
											chk_cucs[i].xweight=$('#'+objnamea+'_'+n).val();
		                        	 	break;
									}
								}
							});
							
							$(this).keyup(function(e) {
								if(e.which>=37 && e.which<=40){return;}
								var tmp=$(this).val();
								tmp=tmp.match(/\d{1,}\.{0,1}\d{0,}/);
								$(this).val(tmp);
							});
						});
						
						//完工
						$('#cucs .cucs_mins').unbind('click');
						$('#cucs .cucs_mins').click(function(e) {
							if($(this).prop('checked')){
								if(confirm("確認要完工?")){
									var n=$(this).attr('id').replace('cucs_mins','')
									q_func('qtxt.query.enda', 'cuc_vu.txt,enda,'+r_accy+';'+$('#cucs_noa'+n).text()+';'+$('#cucs_noq'+n).text()+';'+r_userno+';'+r_name);
								}else{
									$(this).prop('checked',false);
								}
							}							
						});
						
						//第一次匯入就先核取
						bbsrow=document.getElementById("cucs_table").rows.length-1;//重新取得最新的bbsrow
						if(imp_cucno.length>0){
							for(var i=0;i<bbsrow;i++){
								if($('#cucs_noa'+i).text()==imp_cucno && !$('#cucs_chk'+i).prop('checked')
								&& !$('#cucs_chk'+i).prop('disabled')){ //沒有被核取過的資料 且目前沒被鎖定過
									$('#cucs_chk'+i).prop('checked',true).parent().parent().find('td').css('background', 'darkturquoise');
									var t_where="where=^^ 1=1 and a.noa='"+$('#cucs_noa'+i).text()+"' and b.noq='"+$('#cucs_noq'+i).text()+"' and isnull(b.mins,0)=0 ^^";
									q_gt('cucs_vu', t_where, 0, 0, 0,'getcanlock_'+i, r_accy);
									//$('#cucs_chk'+i).click();
									//$('#cucs_chk'+i).prop('checked',true).parent().parent().find('td').css('background', 'darkturquoise');
								}
							}
							cucs_refresh();
						}
						imp_cucno='';
						
						//移動下一格
						var SeekF= new Array();
						$('input:text,select').each(function() {
							if($(this).attr('disabled')!='disabled')
								SeekF.push($(this).attr('id'));
						});
						$('input:text,select').each(function() {
							$(this).bind('keydown', function(event) {
								if( event.which == 13 || event.which == 40) {
									$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).focus();
									$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).select();
								}
							});
						});
                        Unlock();
                    	break;
                    case 'tocub':
                    	var as = _q_appendData("view_cuc", "", true);
                    	if (as[0] != undefined){
                    		var t_noa='';
                    		var t_noq='';
                    		var t_xmount='';
                    		var t_xcount='';
                    		var t_xweight='';
                    		var t_err='';
                    		for (var i=0;i<chk_cucs.length;i++){
                    			var t_exists=false;
                    			for (var j=0;j<as.length;j++){
                    				if(chk_cucs[i]['noa']==as[j]['noa'] && chk_cucs[i]['noq']==as[j]['noq']){//表示加工排程單存在
                    					if(as[j]['cubno'].split('##')[0]!=r_userno){
                    						t_err+=chk_cucs[i]['ordeno']+'-'+chk_cucs[i]['no2']+"鎖定人員非自己本人!!";
                    					}
                    					/*if(dec(as[j].emount)<dec(chk_cucs[i]['xmount'])){
                    						t_err+=chk_cucs[i]['ordeno']+'-'+chk_cucs[i]['no2']+"加工數量大於未完工數!!";
                    					}
                    					if(dec(as[j].eweight)<dec(chk_cucs[i]['xweight'])){
                    						t_err+=chk_cucs[i]['ordeno']+'-'+chk_cucs[i]['no2']+"加工重量大於未完工重!!";
                    					}*/
                    					t_exists=true;
                    					break;
                    				}
                    			}
                    			if(t_err.length>0){
                    				break;
                    			}else if(!t_exists){
                    				t_err=chk_cucs[i]['ordeno']+'-'+chk_cucs[i]['no2']+"加工排程單不存在!!";
                    				break;
                    			}else{//表示資料正常
                    				if(dec(chk_cucs[i]['xmount'])>0 || dec(chk_cucs[i]['xweight'])>0){
	                    				t_noa=t_noa+chk_cucs[i]['noa']+'^';
			                    		t_noq=t_noq+chk_cucs[i]['noq']+'^';
			                    		t_xmount=t_xmount+dec(chk_cucs[i]['xmount'])+'^';
			                    		t_xcount=t_xcount+dec(chk_cucs[i]['xcount'])+'^';
			                    		t_xweight=t_xweight+dec(chk_cucs[i]['xweight'])+'^';
		                    		}
                    			}
                    		}
                    		if(t_err.length>0){
                    			alert(t_err);
                    		}else if(t_noa.length==0 || t_noq.length==0){
                    			alert('排程加工資料無設定數量或重量。');
                    		}else{
                    			//表身資料更新
                    			//更新庫存
				                var bbtrow=document.getElementById("cuct_table").rows.length-1;
				                for(var j=0;j<bbtrow;j++){
					                if(dec($('#textGmount_'+j).val())!=0 || dec($('#textGweight_'+j).val())!=0){
										var x_product=$('#textProduct_'+j).val();
										var x_spec=$('#textSpec_'+j).val();
										var x_size=$('#textSize_'+j).val();
										var x_lengthb=$('#textLengthb_'+j).val();
										var x_class=$('#textClass_'+j).val();
										var x_edate=$('#textDatea').val();
										if((x_product.length>0 || x_spec.length>0 || x_size.length>0 || x_lengthb.length>0 || x_class.length>0) && x_edate.length>0){
											x_product=emp($('#textProduct_'+j).val())?'#non':$('#textProduct_'+j).val();
											x_spec=emp($('#textSpec_'+j).val())?'#non':$('#textSpec_'+j).val();
											x_size=emp($('#textSize_'+j).val())?'#non':$('#textSize_'+j).val();
											x_lengthb=emp($('#textLengthb_'+j).val())?'#non':$('#textLengthb_'+j).val();
											x_class=emp($('#textClass_'+j).val())?'#non':$('#textClass_'+j).val();
											x_edate=emp($('#textDatea').val())?q_date():$('#textDatea').val();
											q_func('qtxt.query.cucsstkcuct_'+j, 'cuc_vu.txt,stk_vu,'+x_product+';'+x_spec+';'+x_size+';'+x_lengthb+';'+x_class+';'+x_edate+';1');
											stkupdate++;
										}
									}
								}
								//無庫存更新
								if(stkupdate==0){
									var t_datea=emp($('#textDatea').val())?'#non':$('#textDatea').val();
	                    			var t_mechno=emp($('#combMechno').val())?'#non':$('#combMechno').val();
	                    			var t_memo=emp($('#textMemo').val())?'#non':$('#textMemo').val();
	                    			
	                    			//表身資料
	                    			var ts_bbt='';
	                    			var bbtrow=document.getElementById("cuct_table").rows.length-1;
	                    			for(var j=0;j<bbtrow;j++){
	                    				var ts_product=$('#textProduct_'+j).val();
		                    			var ts_ucolor=$('#textUcolor_'+j).val();
										var ts_spec=$('#textSpec_'+j).val();
										var ts_size=$('#textSize_'+j).val();
										var ts_lengthb=$('#textLengthb_'+j).val();
										var ts_class=$('#textClass_'+j).val();
										var ts_gmount=$('#textGmount_'+j).val();
										var ts_gweight=$('#textGweight_'+j).val();
										var ts_avgweight=$('#textAvgweight_'+j).val();
										var ts_memo=$('#textMemo_'+j).val();
										
										//if(!emp(ts_product) || !emp(ts_ucolor) || !emp(ts_spec) || !emp(ts_size) || 
										//	!emp(ts_lengthb) || !emp(ts_class) || !emp(ts_gmount) || !emp(ts_gweight) || !emp(ts_memo)){
										if(dec(ts_gweight)>0 && dec(ts_avgweight)>0){
											ts_bbt=ts_bbt
											+ts_product+"^@^"
											+ts_ucolor+"^@^"
											+ts_spec+"^@^"
											+ts_size+"^@^"
											+dec(ts_lengthb)+"^@^"
											+ts_class+"^@^"
											+dec(ts_gmount)+"^@^"
											+dec(ts_gweight)+"^@^"
											+ts_memo+"^@^"
											+"^#^";
	                    				}
	                    			}
	                    			if(ts_bbt.length==0){
	                    				ts_bbt='#non'
	                    			}
	                    			q_func('qtxt.query.cucstocub', 'cuc_vu.txt,cucstocub,'
	                    			+r_accy+';'+t_datea+';'+t_mechno+';'+t_memo+';'
	                    			+r_userno+';'+r_name+';'+t_noa+';'+t_noq+';'+t_xmount+';'+t_xcount+';'+t_xweight+';'+ts_bbt);
	                    			//取消刷新
	                    			clearInterval(intervalupdate);
								}
							}
                    	}else{
                            alert('無排程單!!');
                    	}
                    	Unlock();
                    	break;
					case 'spec':
						var as = _q_appendData("spec", "", true);
						t_spec='@';
						for ( i = 0; i < as.length; i++) {
							t_spec+=","+as[i].noa;
						}
						$('#cuct_table .comb').each(function(index) {
							//帶入選項值
							var n=$(this).attr('id').split('_')[1];
							var objname=$(this).attr('id').split('_')[0];
							if(objname=='combSpec'){
								$(this).text(''); //清空資料
								q_cmbParse("combSpec_"+n, t_spec);
							}
						});
						$('#cucu_table .comb').each(function(index) {
							//帶入選項值
							var n=$(this).attr('id').split('__')[1];
							var objname=$(this).attr('id').split('__')[0];
							if(objname=='combSpec'){
								$(this).text(''); //清空資料
								q_cmbParse("combSpec__"+n, t_spec);
							}
						});
						break;
					case 'color':
						var as = _q_appendData("color", "", true);
						t_ucolor='@';
						for ( i = 0; i < as.length; i++) {
							t_ucolor+=","+as[i].color;
						}
						$('#cuct_table .comb').each(function(index) {
							//帶入選項值
							var n=$(this).attr('id').split('_')[1];
							var objname=$(this).attr('id').split('_')[0];
							if(objname=='combUcolor'){
								$(this).text(''); //清空資料
								q_cmbParse("combUcolor_"+n, t_ucolor);
							}
						});
						$('#cucu_table .comb').each(function(index) {
							//帶入選項值
							var n=$(this).attr('id').split('__')[1];
							var objname=$(this).attr('id').split('__')[0];
							if(objname=='combUcolor'){
								$(this).text(''); //清空資料
								q_cmbParse("combUcolor__"+n, t_ucolor);
							}
						});
						break;
					case 'class':
						var as = _q_appendData("class", "", true);
						t_class='@';
						for ( i = 0; i < as.length; i++) {
							t_class+=","+as[i].noa;
						}
						$('#cuct_table .comb').each(function(index) {
							//帶入選項值
							var n=$(this).attr('id').split('_')[1];
							var objname=$(this).attr('id').split('_')[0];
							if(objname=='combClass'){
								$(this).text(''); //清空資料
								q_cmbParse("combClass_"+n, t_class);
							}
						});
						$('#cucu_table .comb').each(function(index) {
							//帶入選項值
							var n=$(this).attr('id').split('__')[1];
							var objname=$(this).attr('id').split('__')[0];
							if(objname=='combClass'){
								$(this).text(''); //清空資料
								q_cmbParse("combClass__"+n, t_class);
							}
						});
						break;
					case 'mech':
						var as = _q_appendData("mech", "", true);
						t_mech='@';
						for ( i = 0; i < as.length; i++) {
							t_mech+=","+as[i].noa+"@"+as[i].mech;
						}
						$('#combMechno').text();
						q_cmbParse("combMechno", t_mech);
						break;
					case 'nouno_getuno':
						var as = _q_appendData("view_cubs", "", true);
						if (as[0] != undefined) {
							var t_nouno=$.trim($('#textNouno').val()).split(',');
							var tt_nouno='';
							var t_mount=0,t_weight=0;
							for (var i=0;i<t_nouno.length;i++){
								var t_exists=false;
								for (var j=0;j<as.length;j++){
									if(as[j].uno==t_nouno[i]){
										t_exists=true;
										t_mount=q_add(t_mount,dec(as[j].mount));
										t_weight=q_add(t_mount,dec(as[j].weight));
									}
								}
								if(!t_exists){
									alert("批號【"+t_nouno[i]+"】不存在或已領料!!")
									tt_nouno='';
									break;
								}else if(t_mount<=0 && t_mount<=0){
									alert("批號【"+t_nouno[i]+"】已領料!!")
									tt_nouno='';
									break;
								}else{
									tt_nouno=tt_nouno+t_nouno[i]+"#";
								}
							}
							var t_mechno=emp($('#combMechno').val())?'#non':$('#combMechno').val();
							
							if(tt_nouno.length>0)
								q_func('qtxt.query.cubnouno', 'cub.txt,cubnouno_vu,' + encodeURI(r_accy) + ';' + encodeURI(tt_nouno)+ ';' + encodeURI(t_mechno)+ ';' + encodeURI(r_userno)+ ';' + encodeURI(r_name));
						}else{
							alert("批號不存在!!");
						}
						break;
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
				if(t_name.indexOf("getcanlock_")>-1){
					var n=t_name.split('_')[1];
					var as = _q_appendData("view_cuc", "", true);
					if (as[0] != undefined){//是否有資料
						var cubno=as[0].cubno;
						var islock=false;
						if(cubno!=''){
							var lock_time=cubno.split('##')[3]!=undefined?cubno.split('##')[3]:'';
							if(lock_time.length>0){
								islock=true;
								var now_time = new Date();
								lock_time = new Date(lock_time);
								var diff = now_time - lock_time;
								if(diff>1000 * 60 * 30) //超過30分表示已解除鎖定
									islock=false;
							}
						}
						if(islock && cubno!='' && cubno.split('##')[0] != r_userno){//其他人被鎖定
							var mechno=cubno.split('##')[2]!=undefined?cubno.split('##')[2]:'';
							var tt_mech=t_mech.split(',');
							for(var k=0;k<tt_mech.length;k++){
								if(tt_mech[k].split('@')[0]==mechno){
									mechno=tt_mech[k].split('@')[1];
									break;
								}
							}
							alert("該筆排程已被"+mechno+"鎖定!!");
							$('#cucs_lbla'+n).text(mechno);
							$('#cucs_cubno'+n).text(cubno);
							$('#cucs_chk'+n).prop("checked",false).attr('disabled', 'disabled').parent().parent().find('td').css('background', 'lavender');
							$('#cucs_tr'+n+' .co1').css('background-color', 'antiquewhite');
                            $('#cucs_tr'+n+' .co2').css('background-color', 'lightpink');
                            $('#cucs_tr'+n+' .co3').css('background-color', 'lightsalmon');	
                        	//檢查是否有暫存 並刪除暫存資料
                        	 for(var i =0 ;i<chk_cucs.length;i++){
                        	 	if(chk_cucs[i].noa==$('#cucs_noa'+n).text() && chk_cucs[i].noq==$('#cucs_noq'+n).text()){
                        	 		chk_cucs.splice(i, 1);
                        	 		break;
                        	 	}
                        	 }
                        	//關閉欄位修改
                        	$('#textXmount_'+n).val('').attr('disabled', 'disabled');
                            $('#textXcount_'+n).val('').attr('disabled', 'disabled');
                            $('#textXweight_'+n).val('').attr('disabled', 'disabled');
						}else{//未鎖定資料
							$('#cucs_chk'+n).prop("checked",true).parent().parent().find('td').css('background', 'darkturquoise');
							//鎖定資料
                        	q_func('qtxt.query.lock', 'cuc_vu.txt,lock,'+r_accy+';'+$('#cucs_noa'+n).text()+';'+$('#cucs_noq'+n).text()+';'+r_userno+';'+r_name+';'+$('#combMechno').val());
                        	var t_datea=new Date();
                        	t_datea=t_datea.getFullYear()+'-'+(t_datea.getMonth()+1>9?t_datea.getMonth():'0'+(t_datea.getMonth()+1))
                        	+'-'+(t_datea.getDate()+1>9?t_datea.getDate():'0'+t_datea.getDate())
                        	+' '+(t_datea.getHours()+1>9?t_datea.getHours():'0'+t_datea.getHours())
                        	+':'+(t_datea.getMinutes()+1>9?t_datea.getMinutes():'0'+t_datea.getMinutes())
                        	+':'+(t_datea.getSeconds()+1>9?t_datea.getSeconds():'0'+t_datea.getSeconds())
                        	$('#cucs_cubno'+n).text(r_userno+"##"+r_name+"##"+$('#combMechno').val()+"##"+t_datea);
                        	//暫存資料
                        	chk_cucs.push({
								noa : $('#cucs_noa'+n).text(),
								noq : $('#cucs_noq'+n).text(),
								xmount : $('#textXmount_'+n).val(),
								xcount : $('#textXcount_'+n).val(),
								xweight : $('#textXweight_'+n).val(),
								ordeno:$('#cucs_ordeno'+n).text(),
								no2:$('#cucs_no2'+n).text()
							});
                        	//開放欄位修改
                        	$('#textXmount_'+n).removeAttr('disabled');
							$('#textXcount_'+n).removeAttr('disabled');
							$('#textXweight_'+n).removeAttr('disabled');
						}
					}else{
						$('#cucs_chk'+n).prop("checked",false).attr('disabled', 'disabled').parent().parent().find('td').css('background', 'lavender');
						$('#cucs_tr'+n+' .co1').css('background-color', 'antiquewhite');
						$('#cucs_tr'+n+' .co2').css('background-color', 'lightpink');
						$('#cucs_tr'+n+' .co3').css('background-color', 'lightsalmon');	
						alert('該筆排程已完工!!');
					}
					//Unlock();
				}
				if(t_name.indexOf("getcanunlock_")>-1){
					var n=t_name.split('_')[1];
					var as = _q_appendData("view_cuc", "", true);
					if (as[0] != undefined){//是否有資料
						if(as[0].cubno==''){
							$('#cucs_cubno'+n).text('');
							$('#cucs_chk'+n).prop("checked",false).parent().parent().find('td').css('background', 'lavender');
							$('#cucs_tr'+n+' .co1').css('background-color', 'antiquewhite');
                            $('#cucs_tr'+n+' .co2').css('background-color', 'lightpink');
                            $('#cucs_tr'+n+' .co3').css('background-color', 'lightsalmon');
							alert('該筆排程已被解除鎖定!!');
						}else if(as[0].cubno!='' && as[0].cubno.split('##')[0] != r_userno){//其他人被鎖定
							$('#cucs_cubno'+n).text(as[0].cubno);
							$('#cucs_chk'+n).prop("checked",false).attr('disabled', 'disabled').parent().parent().find('td').css('background', 'lavender');
							$('#cucs_tr'+n+' .co1').css('background-color', 'antiquewhite');
                            $('#cucs_tr'+n+' .co2').css('background-color', 'lightpink');
                            $('#cucs_tr'+n+' .co3').css('background-color', 'lightsalmon');
							alert('該筆排程已被鎖定!!');
						}else{//自己鎖定的資料
                        	//取消鎖定資料
                            q_func('qtxt.query.unlock', 'cuc_vu.txt,unlock,'+r_accy+';'+$('#cucs_noa'+n).text()+';'+$('#cucs_noq'+n).text()+';'+r_userno+';'+r_name);
                            $('#cucs_chk'+n).prop("checked",false).parent().parent().find('td').css('background', 'lavender');
                            $('#cucs_tr'+n+' .co1').css('background-color', 'antiquewhite');
                            $('#cucs_tr'+n+' .co2').css('background-color', 'lightpink');
                            $('#cucs_tr'+n+' .co3').css('background-color', 'lightsalmon');
                            $('#cucs_cubno'+n).text('');
						}
					}else{
						$('#cucs_chk'+n).prop("checked",false).attr('disabled', 'disabled').parent().parent().find('td').css('background', 'lavender');
						$('#cucs_tr'+n+' .co1').css('background-color', 'antiquewhite');
                        $('#cucs_tr'+n+' .co2').css('background-color', 'lightpink');
                        $('#cucs_tr'+n+' .co3').css('background-color', 'lightsalmon');	
						alert('該筆排程已完工!!');
					}
					//刪除暫存資料
					for(var i =0 ;i<chk_cucs.length;i++){
                    	if(chk_cucs[i].noa==$('#cucs_noa'+n).text() && chk_cucs[i].noq==$('#cucs_noq'+n).text()){
                        	chk_cucs.splice(i, 1);
                        	break;
                        }
					}
					//關閉欄位修改
					$('#textXmount_'+n).val('').attr('disabled', 'disabled');
					$('#textXcount_'+n).val('').attr('disabled', 'disabled');
					$('#textXweight_'+n).val('').attr('disabled', 'disabled');
					
					var cucsno=$('#cucs_noa' + n).text();
					var eweight=dec($('#cucs_eweight' + n).text());
					if(cucsno!='' && eweight<=0){
						$('#cucs_tr'+n).find('td').css('background', 'darkturquoise');
					}
					//Unlock();	
				}
			}
			
			var func_cubno='';
			var nouno_noa=[];
			function q_funcPost(t_func, result) {
                switch(t_func) {
                	case 'qtxt.query.unlockall':
                			//畫面刷新
                			cucsupdata();
                		break;
                	case 'qtxt.query.cucstocub':
                		var as = _q_appendData("tmp0", "", true, true);
                        if (as[0] != undefined) {
                        	func_cubno=as[0].cubno;
                        	q_func('cub_post.post', r_accy + ',' + encodeURI(func_cubno) + ',1');
                        	func_cubno='';
                		}
                		break;
					case 'cub_post.post':
						alert('加工單產生完畢!!');
						//更新畫面
						chk_cucs=[];
						cucsupdata();
						//並重新啟動刷新
						intervalupdate=setInterval("cucsupdata()",1000*60);
						break;
					case 'qtxt.query.cucttocubt':
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
                        	func_cubno=as[0].cubno;
                        	q_func('cub_post.post.cubt', r_accy + ',' + encodeURI(func_cubno) + ',1');
                        	Unlock();
                        	alert('領料完成!!');
                		}
						break;
					case 'cub_post.post.cubt':
						//將領料資料清空
						$('#cuct_table .minut').each(function() {
							$(this).click();
	                    });
						break;
					case 'qtxt.query.enda':
						//更新畫面
						cucsupdata();
						break;
					case 'qtxt.query.cucutocubs':
						//入庫
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
                        	func_cubno=as[0].cubno;
                        	q_func('cub_post.post.2', r_accy + ',' + encodeURI(func_cubno) + ',1');
                        	func_cubno='';
                		}
						break;
					case 'cub_post.post.2':
						Unlock();
                        alert('入庫完成!!');
                        $('#cucu_table .minut').each(function() {
							$(this).click();
	                    });
						//更新畫面
						cucsupdata();
						break;
					case 'qtxt.query.cubnouno':
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
							var t_cubno=as[0].cubno;
							q_func('cub_post.post.nouno', r_accy + ',' + encodeURI(t_cubno) + ',1');
						}
						break;
					case 'cub_post.post.nouno':
						$('#div_nouno').hide();
						alert("批號領料完成!!");
						break;
                }
                if(t_func.indexOf('qtxt.query.getweight_')>-1){
                	var n=t_func.split('_')[1];
                	$('#textAvgweight_'+n).focusin();
                	var as = _q_appendData("tmp0", "", true, true);
					if (as[0] != undefined) {
						var t_weight=0,t_mount=0;
						for (var i=0;i<as.length;i++){
							t_weight=q_add(t_weight,dec(as[0].weight));
							t_mount=q_add(t_mount,dec(as[0].mount));
						}
						$('#lblMount_'+n).text(t_mount);
						$('#lblWeight_'+n).text(t_weight);
						$('#textAvgweight_'+n).val(round(q_div(t_weight,t_mount),3));
						
						if(dec($('#textGmount_'+n).val())>t_mount){
							alert('領料件數大於庫存件數!!');
							$('#textGmount_'+n).val(0);
						}
						
						if(dec($('#textGweight_'+n).val())>t_weight){
							alert('領料重量大於庫存重量!!');
							$('#textGmount_'+n).val(0);
						}
						
						$('#textGweight_'+n).val(q_mul(dec($('#textGmount_'+n).val()),round(q_div(t_weight,t_mount),3)));
					}else{
						$('#textAvgweight_'+n).val(0);
						$('#textGweight_'+n).val(0);
					}
                }
                if(t_func.indexOf('qtxt.query.getweight_')>-1){
                	var n=t_func.split('_')[1];
                	var as = _q_appendData("tmp0", "", true, true);
					if (as[0] != undefined) {
						var t_weight=0,t_mount=0;
						for (var i=0;i<as.length;i++){
							t_weight=q_add(t_weight,dec(as[0].weight));
							t_mount=q_add(t_mount,dec(as[0].mount));
						}
						$('#lblMount_'+n).text(t_mount);
						$('#lblWeight_'+n).text(t_weight);
						$('#textAvgweight_'+n).val(round(q_div(t_weight,t_mount),3));
						
						if(dec($('#textGmount_'+n).val())>t_mount){
							alert('領料件數大於庫存件數!!');
							$('#textGmount_'+n).val(0);
							$('#textMemo_'+n).focus();
						}
						
						if(dec($('#textGweight_'+n).val())>t_weight){
							alert('領料重量大於庫存重量!!');
							$('#textGmount_'+n).val(0);
							$('#textMemo_'+n).focus();
						}
						
						$('#textGweight_'+n).val(q_mul(dec($('#textGmount_'+n).val()),round(q_div(t_weight,t_mount),3)));
					}else{
						alert('無此物品!!');
						$('#textMemo_'+n).focus();
						$('#textGweight_'+n).val(0);
						$('#textGmount_'+n).val(0);
						$('#textAvgweight_'+n).val(0);
					}
                }
                if(t_func.indexOf('qtxt.query.cuctstkupdate_')>-1 && stkupdate>0){
                	stkupdate=stkupdate-1;
                	var n=t_func.split('_')[1];
                	$('#textAvgweight_'+n).focusin();
                	var as = _q_appendData("tmp0", "", true, true);
					if (as[0] != undefined) {
						var t_weight=0,t_mount=0;
						for (var i=0;i<as.length;i++){
							t_weight=q_add(t_weight,dec(as[0].weight));
							t_mount=q_add(t_mount,dec(as[0].mount));
						}
						$('#lblMount_'+n).text(t_mount);
						$('#lblWeight_'+n).text(t_weight);
						$('#textAvgweight_'+n).val(round(q_div(t_weight,t_mount),3));
						
						if(dec($('#textGmount_'+n).val())>t_mount){
							$('#textGmount_'+n).val(0);
						}
						if(dec($('#textGweight_'+n).val())>t_weight){
							$('#textGmount_'+n).val(0);
						}
						
						$('#textGweight_'+n).val(q_mul(dec($('#textGmount_'+n).val()),round(q_div(t_weight,t_mount),3)));
					}else{
						$('#textAvgweight_'+n).val(0);
						$('#textGweight_'+n).val(0);
						$('#textGmount_'+n).val(0);
					}
					
					if(stkupdate==0){
						//直接將cuct 加到cuct
						var t_datea=emp($('#textDatea').val())?'#non':$('#textDatea').val();
	                    var t_mechno=emp($('#combMechno').val())?'#non':$('#combMechno').val();
	                    var t_memo=emp($('#textMemo').val())?'#non':$('#textMemo').val();
						var ts_bbt='';
	                    var bbtrow=document.getElementById("cuct_table").rows.length-1;
	                    var hasbbs=false;
	                    for(var j=0;j<bbtrow;j++){
	                    	var ts_product=$('#textProduct_'+j).val();
		                	var ts_ucolor=$('#textUcolor_'+j).val();
							var ts_spec=$('#textSpec_'+j).val();
							var ts_size=$('#textSize_'+j).val();
							var ts_lengthb=$('#textLengthb_'+j).val();
							var ts_class=$('#textClass_'+j).val();
							var ts_gmount=$('#textGmount_'+j).val();
							var ts_gweight=$('#textGweight_'+j).val();
							var ts_avgweight=$('#textAvgweight_'+j).val();
							var ts_memo=$('#textMemo_'+j).val();
																
							if(!emp(ts_product) || !emp(ts_ucolor) || !emp(ts_spec) || !emp(ts_size) || !emp(ts_lengthb) || !emp(ts_class)){
								hasbbs=true; //有資料
								if (dec(ts_gweight)>0 && dec(ts_avgweight)>0){ //重量>0
									ts_bbt=ts_bbt
									+ts_product+"^@^"
									+ts_ucolor+"^@^"
									+ts_spec+"^@^"
									+ts_size+"^@^"
									+dec(ts_lengthb)+"^@^"
									+ts_class+"^@^"
									+dec(ts_gmount)+"^@^"
									+dec(ts_gweight)+"^@^"
									+ts_memo+"^@^"
									+"^#^";
		                    	}
							}
	                    }
	                    if(!hasbbs){
							alert('無領料資料');
							Unlock();
	                    }else if(ts_bbt.length==0){
	                    	alert('領料重量等於零。');
	                    	Unlock();
	                    }else{
	                    	q_func('qtxt.query.cucttocubt', 'cuc_vu.txt,cucttocubt,'
	                   		+r_accy+';'+t_datea+';'+t_mechno+';'+t_memo+';'+r_userno+';'+r_name+';'+ts_bbt);
	                    }
					}
                }
                //bbsbbt有資料 轉cub 檢查庫存
                if(t_func.indexOf('qtxt.query.cucsstkcuct_')>-1 && stkupdate>0){
                	stkupdate=stkupdate-1;
                	var n=t_func.split('_')[1];
                	$('#textAvgweight_'+n).focusin();
                	var as = _q_appendData("tmp0", "", true, true);
					if (as[0] != undefined) {
						var t_weight=0,t_mount=0;
						for (var i=0;i<as.length;i++){
							t_weight=q_add(t_weight,dec(as[0].weight));
							t_mount=q_add(t_mount,dec(as[0].mount));
						}
						$('#lblMount_'+n).text(t_mount);
						$('#lblWeight_'+n).text(t_weight);
						$('#textAvgweight_'+n).val(round(q_div(t_weight,t_mount),3));
						
						if(dec($('#textGmount_'+n).val())>t_mount){
							alert('領料件數大於庫存件數!!');
							$('#textGmount_'+n).val(0);
							stkupdate=-1;
						}
						if(dec($('#textGweight_'+n).val())>t_weight){
							alert('領料重量大於庫存重量!!');
							$('#textGmount_'+n).val(0);
							stkupdate=-1;
						}
						
						$('#textGweight_'+n).val(q_mul(dec($('#textGmount_'+n).val()),round(q_div(t_weight,t_mount),3)));
					}else{
						$('#textAvgweight_'+n).val(0);
						$('#textGweight_'+n).val(0);
						$('#textGmount_'+n).val(0);
						alert('物品已被領料完!!');
						stkupdate=-1;
					}
					
					if(stkupdate==0){
						var t_datea=emp($('#textDatea').val())?'#non':$('#textDatea').val();
	                    var t_mechno=emp($('#combMechno').val())?'#non':$('#combMechno').val();
	                    var t_memo=emp($('#textMemo').val())?'#non':$('#textMemo').val();
	                    
	                    var t_noa='';
                    	var t_noq='';
                    	var t_xmount='';
                    	var t_xcount='';
                    	var t_xweight='';
                    	var t_err='';
                    	for (var i=0;i<chk_cucs.length;i++){
                    		if(dec(chk_cucs[i]['xmount'])>0 || dec(chk_cucs[i]['xweight'])>0){
	                    		t_noa=t_noa+chk_cucs[i]['noa']+'^';
								t_noq=t_noq+chk_cucs[i]['noq']+'^';
								t_xmount=t_xmount+dec(chk_cucs[i]['xmount'])+'^';
			    				t_xcount=t_xcount+dec(chk_cucs[i]['xcount'])+'^';
								t_xweight=t_xweight+dec(chk_cucs[i]['xweight'])+'^';
							}
                    	}
	                    			
	                    //表身資料
	                    var ts_bbt='';
	                    var bbtrow=document.getElementById("cuct_table").rows.length-1;
	                    for(var j=0;j<bbtrow;j++){
	                    	var ts_product=$('#textProduct_'+j).val();
		                	var ts_ucolor=$('#textUcolor_'+j).val();
							var ts_spec=$('#textSpec_'+j).val();
							var ts_size=$('#textSize_'+j).val();
							var ts_lengthb=$('#textLengthb_'+j).val();
							var ts_class=$('#textClass_'+j).val();
							var ts_gmount=$('#textGmount_'+j).val();
							var ts_gweight=$('#textGweight_'+j).val();
							var ts_avgweight=$('#textAvgweight_'+j).val();
							var ts_memo=$('#textMemo_'+j).val();
										
							if(	(!emp(ts_product) || !emp(ts_ucolor) || !emp(ts_spec) || !emp(ts_size) || !emp(ts_lengthb) || !emp(ts_class))
							&&dec(ts_gweight)>0 && dec(ts_avgweight)>0){
								ts_bbt=ts_bbt
								+ts_product+"^@^"
								+ts_ucolor+"^@^"
								+ts_spec+"^@^"
								+ts_size+"^@^"
								+dec(ts_lengthb)+"^@^"
								+ts_class+"^@^"
								+dec(ts_gmount)+"^@^"
								+dec(ts_gweight)+"^@^"
								+ts_memo+"^@^"
								+"^#^";
							}
						}
	                    if(ts_bbt.length==0){
	                    	ts_bbt='#non'
						}
	                    q_func('qtxt.query.cucstocub', 'cuc_vu.txt,cucstocub,'
	                    +r_accy+';'+t_datea+';'+t_mechno+';'+t_memo+';'
	                    +r_userno+';'+r_name+';'+t_noa+';'+t_noq+';'+t_xmount+';'+t_xcount+';'+t_xweight+';'+ts_bbt);
	                    //取消刷新
	                    clearInterval(intervalupdate);
					}
                }
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
			
			function cucs_refresh() {
				var bbsrow=document.getElementById("cucs_table").rows.length-1;
				for (var i=0;i<bbsrow;i++){
					var cubno=$('#cucs_cubno' + i).text();
					var cucsno=$('#cucs_noa' + i).text();
					var eweight=dec($('#cucs_eweight' + i).text());
					$('#textXmount_'+i).val('').attr('disabled', 'disabled');
					$('#textXcount_'+i).val('').attr('disabled', 'disabled');
					$('#textXweight_'+i).val('').attr('disabled', 'disabled');
					if(cubno!=''){
						var lock_time=cubno.split('##')[3]!=undefined?cubno.split('##')[3]:'';
						var islock=false;
						if(lock_time.length>0){
							islock=true;
							var now_time = new Date();
							lock_time = new Date(lock_time);
							var diff = now_time - lock_time;
							if(diff>1000 * 60 * 30) //超過30分表示已解除鎖定
								islock=false;
						}
						if(islock && cubno.split('##')[0]!=r_userno){//其他人鎖定
							var mechno=cubno.split('##')[2]!=undefined?cubno.split('##')[2]:'';
							var tt_mech=t_mech.split(',');
							for(var k=0;k<tt_mech.length;k++){
								if(tt_mech[k].split('@')[0]==mechno){
									mechno=tt_mech[k].split('@')[1];
									break;
								}
							}
							
							$('#cucs_lbla'+i).text(mechno);
							$('#cucs_chk' + i).attr('disabled', 'disabled');
                            $('#cucs_chk'+i).prop('checked',false).parent().parent().find('td').css('background', 'lavender');
                            $('#cucs_tr'+i+' .co1').css('background-color', 'antiquewhite');
                            $('#cucs_tr'+i+' .co2').css('background-color', 'lightpink');
                            $('#cucs_tr'+i+' .co3').css('background-color', 'lightsalmon');
                            $('#cucs_mins' + i).attr('disabled', 'disabled');
						}else if (islock && cubno.split('##')[0]==r_userno){//自己鎖定
							$('#cucs_lbla'+i).text('');
							$('#cucs_chk' + i).removeAttr('disabled');
                            $('#cucs_chk'+i).prop('checked',true).parent().parent().find('td').css('background', 'darkturquoise');
                            $('#combMechno').val(cubno.split('##')[2]!=undefined?cubno.split('##')[2]:'');
                            $('#cucs_mins' + i).removeAttr('disabled');
                            //text寫入
                            for(var j =0 ;j<chk_cucs.length;j++){
                            	if(chk_cucs[j].noa==$('#cucs_noa'+i).text() && chk_cucs[j].noq==$('#cucs_noq'+i).text()){
		                            $('#textXmount_'+i).val(chk_cucs[j].xmount).removeAttr('disabled');
									$('#textXcount_'+i).val(chk_cucs[j].xcount).removeAttr('disabled');
									$('#textXweight_'+i).val(chk_cucs[j].xweight).removeAttr('disabled');
									break;
								}
							}
						}else{ //超過鎖定時間
							$('#cucs_lbla'+i).text('');
							$('#cucs_chk' + i).removeAttr('disabled');
							$('#cucs_chk'+i).prop('checked',false).parent().parent().find('td').css('background', 'lavender');
							$('#cucs_mins' + i).removeAttr('disabled');
							$('#cucs_tr'+i+' .co1').css('background-color', 'antiquewhite');
                            $('#cucs_tr'+i+' .co2').css('background-color', 'lightpink');
                            $('#cucs_tr'+i+' .co3').css('background-color', 'lightsalmon');
						}
					}else{//無人鎖定
						$('#cucs_lbla'+i).text('');
						$('#cucs_chk' + i).removeAttr('disabled');
						$('#cucs_chk'+i).prop('checked',false).parent().parent().find('td').css('background', 'lavender');
						$('#cucs_mins' + i).removeAttr('disabled');
						$('#cucs_tr'+i+' .co1').css('background-color', 'antiquewhite');
						$('#cucs_tr'+i+' .co2').css('background-color', 'lightpink');
						$('#cucs_tr'+i+' .co3').css('background-color', 'lightsalmon');
					}
					
					if(cucsno!='' && eweight<=0){
						$('#cucs_tr'+i).find('td').css('background', 'darkturquoise');
					}
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
				background: lavender;
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
				width: 71%;
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
			.dbbs .tbbs {
				margin: 0;
				padding: 2px;
				border: 2px lightgrey double;
				border-spacing: 1px;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				background: lavender;
				width: 100%;
			}
			.dbbs .tbbs tr {
				height: 35px;
			}
			.dbbs .tbbs tr td {
				text-align: center;
				border: 2px lightgrey double;
			}
			#cucs_table {
                border: 5px solid gray;
                font-size: medium;
                background-color: white;
            }
            #cucs_table tr {
                height: 30px;
            }
            #cucs_table td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: lavender;
                color: blue;
            }
            #cucs_table .co1{
                background-color: antiquewhite;
            }
            #cucs_table .co2{
                background-color: lightpink;
            }
            #cucs_table .co3{
                background-color: lightsalmon;
            }
            
            #cucs_table2 {
                border: 5px solid gray;
                font-size: medium;
                background-color: white;
            }
            #cucs_table2 tr {
                height: 30px;
            }
            #cucs_table2 td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: lavender;
                color: blue;
            }
            #cucs_table2 .co1{
                background-color: antiquewhite;
            }
            #cucs_table2 .co2{
                background-color: lightpink;
            }
            #cucs_table2 .co3{
                background-color: lightsalmon;
            }
            
            #cuct_table {
                border: 5px solid gray;
                font-size: medium;
                background-color: white;
            }
            #cuct_table tr {
                height: 30px;
            }
            #cuct_table td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: lightblue;
                color: blue;
            }
            
            #cuct_table2 {
                border: 5px solid gray;
                font-size: medium;
                background-color: white;
            }
            #cuct_table2 tr {
                height: 30px;
            }
            #cuct_table2 td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: lightblue;
                color: blue;
            }
            
             #cucu_table {
                border: 5px solid gray;
                font-size: medium;
                background-color: white;
            }
            #cucu_table tr {
                height: 30px;
            }
            #cucu_table td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: gold;
                color: blue;
            }
            
            #cucu_table2 {
                border: 5px solid gray;
                font-size: medium;
                background-color: white;
            }
            #cucu_table2 tr {
                height: 30px;
            }
            #cucu_table2 td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: gold;
                color: blue;
            }
            
		</style>
	</head>
	<body>
		<div id='q_menu'> </div>
		<div id='q_acDiv'> </div>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type='button' id='btnAuthority' name='btnAuthority' style='font-size:16px;' value='權限'/>
		<BR>
		<a class="lbl">加工日</a>&nbsp;<input id="textDatea"  type="text" class="txt" style="width: 100px;"/>&nbsp;
		<a class="lbl">機　台</a>&nbsp;
			<select id="combMechno" class="txt" style="font-size: medium;"> </select>
			<!--<input id="textMechno"  type="text" class="txt " style="width: 100px;"/>
			<input id="textMech"  type="text" class="txt" style="width: 100px;" disabled="disabled"/>-->
		<a class="lbl">備　註</a>&nbsp;<input id="textMemo"  type="text" class="txt" style="width: 500px;"/>
		<input type='button' id='btnCub' style='font-size:16px;' value="入庫"/>
		<input type='button' id='btnCancels' style='font-size:16px;' value="取消鎖定"/>
		<input type='button' id='btnClear' style='font-size:16px;' value="完工"/>
		<input type='button' id='btnStk' style='font-size:16px;' value="庫存表"/>
		<BR>
		<a class="lbl">案　號</a>&nbsp;
		<select id="combCucno" class="txt" style="font-size: medium;"> </select>
		&nbsp;<a class="lbl">號　數</a>&nbsp;
		<select id="combSize" class="txt" style="font-size: medium;"> </select>
		<input type='button' id='btnImport' style='font-size:16px;' value="匯入"/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a style="color: red;">※鎖定時間超過半小時將自動解除鎖定</a>
		<div id="cucs" style="float:left;width:100%;height:500px;overflow:auto;position: relative;"> </div> 
		<!--<div id="cucs_control" style="width:100%;"> </div>--> 
		<div id="cuct" style="float:left;width:100%;height:110px;overflow:auto;position: relative;"> </div>
		<div id="cucu" style="float:left;width:100%;height:110px;overflow:auto;position: relative;"> </div>
		<div id="div_nouno" style="position:absolute; top:70px; left:840px; display:none; width:400px; background-color: #CDFFCE; border: 1px solid gray;">
			<table id="table_nouno" style="width:100%;" border="1" cellpadding='2'  cellspacing='0'>
				<tr>
					<td style="background-color: #f8d463;width: 150px;" align="center">批號</td>
					<td style="background-color: #f8d463;width: 250px;"><input id="textNouno" type="text" class="txt c1"/></td>
				</tr>
				<tr id='nouno_close'>
					<td align="center" colspan='2'>
						<input id="btnOk_div_nouno" type="button" value="領料">
						<input id="btnClose_div_nouno" type="button" value="取消">
					</td>
				</tr>
			</table>
		</div>
	</body>
</html>