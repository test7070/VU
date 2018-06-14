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
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"> </script>
		<script src="css/jquery/ui/jquery.ui.widget.js"> </script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"> </script>
		<script type="text/javascript">
            this.errorHandler = null;
            function onPageError(error) {
                alert("An error occurred:\r\n" + error.Message);
            }
			q_desc=1;
			q_copy=1;
            q_tables = 's';
            var q_name = "cuc";
            var q_readonly = ['txtWorker', 'txtWorker2','textWeight','textWeight1','textWeight2','textWeight3','textWeight4'];
            var q_readonlys = ['txtPicname'];
            var bbmNum = [];
            var bbsNum = [['txtParaa', 15, 0, 1], ['txtParab', 15, 0, 1], ['txtParac', 15, 0, 1], ['txtParad', 15, 0, 1], ['txtParae', 15, 0, 1]];
            var bbmMask = [];
            var bbsMask = [];
            q_sqlCount = 6;
            brwCount = 6;
            brwList = [];
            brwNowPage = 0;
            brwKey = 'Noa';
            brwCount2 = 7;
            aPop = new Array(
            	['txtCustno', 'lblCust', 'cust', 'noa,nick', 'txtCustno,txtCust', 'cust_b.aspx'],
            	['txtPicno_', 'btnPicno_', 'img', 'noa,namea', 'txtPicno_,txtPicname_', 'img_b.aspx']
            );

            $(document).ready(function() {
                bbmKey = ['noa'];
                bbsKey = ['noa', 'noq'];
                q_bbsLen = 30; //106/08/09
                q_brwCount();
                q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
                q_gt('spec', '1=1 ', 0, 0, 0, "bbsspec");
                q_gt('color', '1=1 ', 0, 0, 0, "bbscolor");
				q_gt('class', '1=1 ', 0, 0, 0, "bbsclass");
            });

            //////////////////   end Ready
            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }
                mainForm(1);
            }
			
			var splicerdiv=false;
            function mainPost() {
            	bbsNum = [ ['txtMount', 10, q_getPara('vcc.mountPrecision'), 1], ['txtMount1', 10, q_getPara('vcc.mountPrecision'), 1], ['txtWeight', 10, q_getPara('vcc.weightPrecision'), 1], ['txtLengthb', 15, 2, 1]];//['txtPrice', 12, q_getPara('vcc.pricePrecision'), 1],
                q_getFormat();
                bbmMask = [['txtDatea', r_picd],['txtBdate', r_picd]];
                bbsMask = [];
                q_mask(bbmMask);
				//q_cmbParse("combProduct", q_getPara('vccs_vu.product'),'s');
				q_cmbParse("cmbBtime", ',棕,紅,白,黃,綠,灰,藍','s');
				q_cmbParse("cmbEtime", ',棕,紅,白,黃,綠,灰,藍','s');
				q_cmbParse("cmbMount2", '0@,1@1,2@2','s');
				q_cmbParse("cmbScolor", ',續接器-直牙,續接器-錐牙,續接器-T頭','s');
				q_cmbParse("combParaf1", ',#6,#7,#8,#9,#10,#11,#12','s');
				q_cmbParse("combParag1", ',#6,#7,#8,#9,#10,#11,#12','s');
				q_cmbParse("combParaf2", ',公,母,T','s');
				q_cmbParse("combParag2", ',公,母,T','s');
				
				if(r_len==4){                	
                	$.datepicker.r_len=4;
					//$.datepicker.setDefaults($.datepicker.regional["ENG"]);
                }
				
				var t_where = "where=^^ 1=1 ^^";
				q_gt('ucc', t_where, 0, 0, 0, "");
				
				$('#txtNoa').change(function() {
					$('#txtNoa').val(trim($('#txtNoa').val()));
                    if ($(this).val().length > 0) {
                        t_where = "where=^^ noa='" + $(this).val() + "'^^";
                        q_gt('view_cuc', t_where, 0, 0, 0, "checkCucno_change", r_accy);
                    }
                });
				
				$('#checkGen').click(function() {
					if(q_cur==1 || q_cur==2){
						if($('#checkGen').prop('checked'))
							$('#txtGen').val(1);
						else
							$('#txtGen').val(0);
					}
				});
				
				$('#combProduct').change(function() {
					if(q_cur==1 || q_cur==2){
						$('#txtTypea').val($('#combProduct').find("option:selected").text());
					
						for (var j = 0; j < q_bbsCount; j++) {
		                	if(!emp($('#txtUcolor_'+j).val()) || !emp($('#txtSpec_'+j).val()) || !emp($('#txtSize_'+j).val())){
		                		$('#txtProduct_'+j).val($('#txtTypea').val());
		                	}
		                }
					}
				});
				
				$('#txtCustno').change(function() {
					if(!emp($('#txtCustno').val())){
						q_gt('custms', "where=^^noa='"+$('#txtCustno').val()+"'^^ ", 0, 0, 0, "custms");
					}else{
						$('#combAccount').text('');
					}
				});
				
				$('#combAccount').change(function() {
					if(q_cur==1 || q_cur==2)
						$('#txtMech').val($('#combAccount').find("option:selected").text());
				});
				
				$('#btnShowpara').click(function() {
					if($(this).val()=='參數顯示'){
						$(this).val('參數關閉');
					}else{
						$(this).val('參數顯示');
					}
					bbswidth();
				});
				
				$('#lblWeight4').click(function() {
					//清除表身資料
					var rowslength=document.getElementById("tbbssplicer").rows.length-1;
					for (var j = 0; j < rowslength; j++) {
						document.getElementById("tbbssplicer").deleteRow(1);
					}
					var string='',t_j=0;
					for (var j = 0; j < q_bbsCount; j++) {
						if(dec($('#cmbMount2_'+j).val())>0){
							string+='<tr id="trbbs'+j+'" style="background:'+(t_j%2==0?'skyblue':'aliceblue')+'">';
							string+='<td style="text-align: center;display: none;">'+$('#txtNoq_'+j).val()+'</td>';
							string+='<td style="text-align: center;">'+$('#txtOrdeno_'+j).val()+'/'+$('#txtNo2_'+j).val()+'</td>';
							string+='<td style="text-align: center;">'+$('#txtSpec_'+j).val()+'</td>';
							string+='<td style="text-align: center;">'+$('#txtSize_'+j).val()+'</td>';
							string+='<td style="text-align: center;">'+$('#txtLengthb_'+j).val()+'</td>';
							string+='<td style="text-align: center;">'+$('#txtMount1_'+j).val()+'</td>';
							string+='<td style="text-align: center;">'+$('#txtWeight_'+j).val()+'</td>';
							string+='<td style="text-align: center;">'+$('#cmbMount2_'+j).val()+'</td>';
							string+='<td style="text-align: center;"><select id="combScolor_'+j+'" class="txt comb combScolor c1"> </select></td>';
							string+='<td style="text-align: center;"><select id="combParafa_'+j+'" class="txt comb combParafa"> </select><select id="combParafb_'+j+'" class="txt comb combParafb"> </select>';
							string+='<a>---</a><select id="combParaga_'+j+'" class="txt comb combParaga"> </select><select id="combParagb_'+j+'" class="txt comb combParagb"> </select></td>';
							string+='<td style="text-align: center;">'+(dec($('#txtRadius_'+j).val())>0?'V':'')+'</td>';
							string+='<td style="text-align: center;"><img id="timgpic'+j+'" src="'+$('#imgPic_'+j).attr('src')+'" style="width:100px;"></td>';
							string+='<td style="text-align: center;">'+$('#txtMemo_'+j).val()+'</td>';
							t_j++;
						}
					}
					if(string.length>0 && !splicerdiv){
						$('#tbbssplicer').append(string);
						
						$('.combScolor').each(function(index) {
							var t_id=$(this).attr('id');
							var t_n=$(this).attr('id').split('_')[1];
							q_cmbParse(t_id, ',續接器-直牙,續接器-錐牙,續接器-T頭');
							$('#'+t_id).val($('#cmbScolor_'+t_n).val());
							
							$(this).change(function() {
								var t_ns=$(this).attr('id').split('_')[1];
								$('#cmbScolor_'+t_ns).val($(this).val());
							});
						});
						
						$('.combParafa').each(function(index) {
							var t_id=$(this).attr('id');
							var t_n=$(this).attr('id').split('_')[1];
							q_cmbParse(t_id, ',#6,#7,#8,#9,#10,#11,#12');
							$('#'+t_id).val($('#combParaf1_'+t_n).val());
							
							$(this).change(function() {
								var t_ns=$(this).attr('id').split('_')[1];
								$('#combParaf1_'+t_ns).val($(this).val());
								$('#combParaf1_'+t_ns).change();
							});
						});
						
						$('.combParaga').each(function(index) {
							var t_id=$(this).attr('id');
							var t_n=$(this).attr('id').split('_')[1];
							q_cmbParse(t_id, ',#6,#7,#8,#9,#10,#11,#12');
							$('#'+t_id).val($('#combParag1_'+t_n).val());
							
							$(this).change(function() {
								var t_ns=$(this).attr('id').split('_')[1];
								$('#combParag1_'+t_ns).val($(this).val());
								$('#combParag1_'+t_ns).change();
							});
						});
						
						$('.combParafb').each(function(index) {
							var t_id=$(this).attr('id');
							var t_n=$(this).attr('id').split('_')[1];
							q_cmbParse(t_id, ',公,母,T');
							$('#'+t_id).val($('#combParaf2_'+t_n).val());
							
							$(this).change(function() {
								var t_ns=$(this).attr('id').split('_')[1];
								$('#combParaf2_'+t_ns).val($(this).val());
								$('#combParaf2_'+t_ns).change();
							});
						});
						
						$('.combParagb').each(function(index) {
							var t_id=$(this).attr('id');
							var t_n=$(this).attr('id').split('_')[1];
							q_cmbParse(t_id, ',公,母,T');
							$('#'+t_id).val($('#combParag2_'+t_n).val());
							
							$(this).change(function() {
								var t_ns=$(this).attr('id').split('_')[1];
								$('#combParag2_'+t_ns).val($(this).val());
								$('#combParag2_'+t_ns).change();
							});
						});
						
						$('.dbbs').hide();
						$('#splicertotal').show();
						$('#dbbssplicer').show();
						comb_disabled();
						splicerdiv=true;
					}else{
						$('#splicertotal').hide();
						$('#dbbssplicer').hide();
						$('.dbbs').show();
						splicerdiv=false;
					}
				});
                
                $('#lblNoa').text('案號'); 
                $('#lblCust').text('客戶名稱');
                $('#lblMemo').text('備註');
                $('#lblDatea').text('日期'); 
                //$('#lblGen').text('取消'); 
                $('#lblGen').text('結案');
                $('#lblBdate').text('預交日');
                $('#lblMech').text('工地名稱');
                $('#lblWeight').text('料單總重量');
                $('#lblProduct').text('品名');
            }

            function q_popPost(s1) {
                switch(s1) {
                	case 'txtPicno_':
                		var n = b_seq;
                		t_noa = $('#txtPicno_'+n).val();
                		//console.log('popPost:'+t_noa);
                		if(t_noa.length>0)
                			q_gt('img', "where=^^noa='"+t_noa+"'^^", 0, 0, 0, JSON.stringify({action:"getimg",n:n}),1);
                		else{
                        	$('#txtPicname_'+n).val('');
                        	$('#txtImgorg_'+n).val('');
				            $('#txtImgdata_'+n).val('');
				            $('#txtImgbarcode_'+n).val('');
				            var c=document.getElementById("canvas_"+n);
				            var cxt=c.getContext("2d");
				    		c.height=c.height;
				            $('#imgPic_'+n).attr('src','');
                		}
                	break;
                }
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

            function q_gtPost(t_name) {
                switch (t_name) {
                	case 'checkCucno_change':
						var as = _q_appendData("view_cuc", "", true);
                        if (as[0] != undefined) {
                            alert('案號【'+as[0].noa+'】已存在!!!');
                        }else{
                        	//107/04/11修改單
                        	for (var j = 0; j < q_bbsCount; j++) {
			                	if(!emp($('#txtUcolor_'+j).val()) || !emp($('#txtSpec_'+j).val()) || !emp($('#txtSize_'+j).val())){
			                		$('#txtOrdeno_'+j).val($('#txtNoa').val());
			                	}
		                	}
                        }
                        break;
                	case 'checkCucno_btnOk':
                		var as = _q_appendData("view_cuc", "", true);
                        if (as[0] != undefined) {
                            alert('案號【'+as[0].noa+'】已存在!!!');
                            return;
                        } else {
                            wrServer($('#txtNoa').val());
                        }
                        break;
                	case 'custms':
                		var as = _q_appendData("custms", "", true);
                		var t_account='@';
                		for ( i = 0; i < as.length; i++) {
                			if(as[i].account!='')
                				t_account+=","+as[i].account;
                		}
                		$('#combAccount').text('');
                		q_cmbParse("combAccount", t_account);
                		break;
                	case 'ucc':
						var as = _q_appendData("ucc", "", true);
						var t_ucc='@';
						for ( i = 0; i < as.length; i++) {
							t_ucc+=","+as[i].product;
						}
						q_cmbParse("combProduct", t_ucc);
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
                    case q_name:
                        if (q_cur == 4)
                            q_Seek_gtPost();
                        break;
                    default:
                    	try{
                    		var t_para = JSON.parse(t_name);
                    		if(t_para.action=="getimg"){
                    			var n = t_para.n;
                    			as = _q_appendData("img", "", true);
                    			if(as[0]!=undefined){
                    				$('#txtPara_'+n).val(as[0].para);
                    				$('#txtImgorg_'+n).val(as[0].org);
                    			}else{
                    				$('#txtPara_'+n).val('');
                    				$('#txtImgorg_'+n).val('');
                    			}
                    			createImg(n);
                    		}else if(t_para.action=="createimg" || t_para.action=="createimg_btnOk"){
                    			alert('錯誤!!');
							}
                    	}catch(e){
                    		Unlock(1);
                    	}
                        break;
                }
            }
            
            function createImg(n){
				var t_picno = $('#txtPicno_'+n).val();
				var t_para = $('#txtPara_'+n).val();
                var t_imgorg = $('#txtImgorg_'+n).val();
				try{
					t_para = JSON.parse(t_para);
				}catch(e){
					console.log('createImg:'+t_para);
				}
				if(t_imgorg.length==0)
					return;
				//$('#imgPic_'+n).attr('src',t_imgorg);
				var image = document.getElementById('imgPic_'+n);
				image.src=t_imgorg;
                var imgwidth = 300;
                var imgheight = 100;
                $('#canvas_'+n).width(imgwidth).height(imgheight);
                var c = document.getElementById("canvas_"+n);
				var ctx = c.getContext("2d");		
				c.width = imgwidth;
				c.height = imgheight;
				image.onload = function() {
					ctx.drawImage($('#imgPic_'+n)[0],0,0,imgwidth,imgheight);
					var t_length = 0;
					createImg2(n);
				}
			};
			
			function createImg2(n){
				var t_picno = $('#txtPicno_'+n).val();
				var t_para = $('#txtPara_'+n).val();
                var t_imgorg = $('#txtImgorg_'+n).val();
				try{
					t_para = JSON.parse(t_para);
				}catch(e){
					console.log('createImg:'+t_para);
				}
				if(t_imgorg.length==0)
					return;
				var image = document.getElementById('imgPic_'+n)
                var imgwidth = 300;
                var imgheight = 100;
                var c = document.getElementById("canvas_"+n);
				$('#imgPic_'+n).attr('src',c.toDataURL());
				image.onload = function() {
					//條碼用圖形
					xx_width = 355;
					xx_height = 119;						
					$('#canvas_'+n).width(xx_width).height(xx_height);
					c.width = xx_width;
					c.height = xx_height;
					$('#canvas_'+n)[0].getContext("2d").drawImage($('#imgPic_'+n)[0],0,0,imgwidth,imgheight,0,0,xx_width,xx_height);
					
					$('#txtImgbarcode_'+n).val(c.toDataURL());
					createImg3(n);
				}
			};
			
			function createImg3(n){
				var t_picno = $('#txtPicno_'+n).val();
				var t_para = $('#txtPara_'+n).val();
                var t_imgorg = $('#txtImgorg_'+n).val();
				try{
					t_para = JSON.parse(t_para);
				}catch(e){
					console.log('createImg:'+t_para);
				}
				if(t_imgorg.length==0)
					return;
				var image = document.getElementById('imgPic_'+n);
				image.src=t_imgorg;
                var imgwidth = 300;
                var imgheight = 100;
                $('#canvas_'+n).width(imgwidth).height(imgheight);
                var c = document.getElementById("canvas_"+n);
				var ctx = c.getContext("2d");		
				c.width = imgwidth;
				c.height = imgheight;
				image.onload = function() {
					ctx.drawImage($('#imgPic_'+n)[0],0,0,imgwidth,imgheight);
					var t_length = 0;
					for(var i=0;i<t_para.length;i++){
						value = $('#txtPara'+t_para[i].key.toLowerCase()+'_'+n).val();
						if(value!=0){
							t_length += value;
							ctx.font = t_para[i].fontsize+"px Arial";
							ctx.fillStyle = 'black';
							ctx.textAlign="center";
							ctx.fillText(value+'',t_para[i].left,t_para[i].top);
						}
					}
					createImg4(n);
				}
			};
			
			function createImg4(n){
				var t_picno = $('#txtPicno_'+n).val();
				var t_para = $('#txtPara_'+n).val();
                var t_imgorg = $('#txtImgorg_'+n).val();
				try{
					t_para = JSON.parse(t_para);
				}catch(e){
					console.log('createImg:'+t_para);
				}
				if(t_imgorg.length==0)
					return;
				var image = document.getElementById('imgPic_'+n)
                var imgwidth = 300;
                var imgheight = 100;
                var c = document.getElementById("canvas_"+n);
				$('#imgPic_'+n).attr('src',c.toDataURL());
				image.onload = function() {
					//報表用圖形 縮放為150*50
					$('#canvas_'+n).width(150).height(50);
					c.width = 150;
					c.height = 50;
					$('#canvas_'+n)[0].getContext("2d").drawImage($('#imgPic_'+n)[0],0,0,imgwidth,imgheight,0,0,150,50);
					$('#txtImgdata_'+n).val(c.toDataURL());	
					//------------------------------
				}
			};

            function btnOk() {
                var t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')], ['txtDatea', q_getMsg('lblDatea')], ['txtTypea', '品名']]);
                if (t_err.length > 0) {
                    alert(t_err);
                    return;
                }
                t_err='';
                for (var j = 0; j < q_bbsCount; j++) {
                	//107/04/11修改單
                	if(!emp($('#txtUcolor_'+j).val()) || !emp($('#txtSpec_'+j).val()) || !emp($('#txtSize_'+j).val())){
                		$('#txtProduct_'+j).val($('#txtTypea').val());
                	}
                	
                	if (!emp($('#txtProduct_'+j).val()) && (emp($('#txtOrdeno_'+j).val()) || emp($('#txtNo2_'+j).val()))){
                		t_err="【訂單編號/訂序】空白!!";
                		break;
                	}	
                }
                if (t_err.length > 0) {
                    alert(t_err);
                    return;
                }
				
				$('#txtNoa').val(trim($('#txtNoa').val()));
				var t_noa = trim($('#txtNoa').val());
				
                if (q_cur == 1){
                    $('#txtWorker').val(r_name);
                 	t_where = "where=^^ noa='" + t_noa + "'^^";
                    q_gt('view_cuc', t_where, 0, 0, 0, "checkCucno_btnOk", r_accy);   
                }else{
                    $('#txtWorker2').val(r_name);
                    wrServer(t_noa);
				}
				
				t_bbsordegen=false;
                var t_ordeno='';
                
				for(var i=0;i<q_bbsCount;i++){
                	//createImg(i);
                	if(t_ordeno.length==0 && !emp($('#txtOrdeno_'+i).val())){
                		t_ordeno=$('#txtOrdeno_'+i).val();
                	}
                }
                /*
                 11/10 不設定auto手動輸入
                 var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
                var t_date = trim($('#txtDatea').val());
                if (s1.length == 0 || s1 == "AUTO")
                    q_gtnoa(q_name, replaceAll(q_getPara('sys.key_cuc') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
                else
                    wrServer(s1);
                */
            }

            function _btnSeek() {
                if (q_cur > 0 && q_cur < 4)// 1-3
                    return;
                q_box('cuc_vu_s.aspx', q_name + '_s', "500px", "310px", q_getMsg("popSeek"));
            }

            function combPay_chg() {
            }

            function bbsAssign() {
                for (var j = 0; j < q_bbsCount; j++) {
                	if($('#canvas_'+j).length>0){
						$('#imgPic_'+j).attr('src', $('#txtImgdata_'+j).val());
						showimg(j);
                	}
                    if (!$('#btnMinus_' + j).hasClass('isAssign')) {
                    	
                    	for (var k = 0; k < fbbs.length; k++) {
                    		$('#'+fbbs[k]+'_'+j).keydown(function(e) {
                    			t_IdSeq = -1;
								q_bodyId($(this).attr('id'));
								b_seq = t_IdSeq;
								var t_id=$(this).attr('id').split('_')[0];
								
                    			if(e.which=='40'){
                    				if(t_id=='txtLengthb' || t_id=='txtMount1' || t_id=='txtMount'){
                    					bbsweight(b_seq);
                        				weighttotal();
                    				}
                    				
                    				if(q_bbsCount==dec(b_seq)+1){
                    					$('#btnPlus').click();
                    				}
                    			}
							});
                    		
                    		
                    		$('#'+fbbs[k]+'_'+j).focusin(function() {
                    			t_IdSeq = -1;
								q_bodyId($(this).attr('id'));
								b_seq = t_IdSeq;
								
								copybbspre(b_seq);
							});
                    	}
                    	
                    	$('#txtOrdeno_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							$(this).val(trim($(this).val()));
						});
						
                    	$('#combUcolor_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtUcolor_'+b_seq).val($('#combUcolor_'+b_seq).find("option:selected").text());
						});
						
						$('#txtSize_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							 if ($(this).val().substr(0, 1) != '#')
                        		$(this).val('#' + $(this).val());
                        	bbsweight(b_seq);
                        	weighttotal();
						});
						
						$('#combSpec_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtSpec_'+b_seq).val($('#combSpec_'+b_seq).find("option:selected").text());
							//bbsweight(b_seq);
							weighttotal();
						});
						
						$('#txtSpec_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
							weighttotal();
						});
						
						$('#txtLengthb_'+j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							bbsweight(b_seq);
						});
						
						$('#txtMount1_'+j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							bbsweight(b_seq);
							splicertotal();
						});
						
						$('#txtWeight_'+j).change(function() {
							weighttotal();
						}).focusin(function() {
							$(this).select();
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
						
						$('#combParaf_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							/*if(q_cur==1 || q_cur==2){
								$('#txtParaf_'+b_seq).val($('#combParaf_'+b_seq).find("option:selected").text());
								//createImg(b_seq);
							}*/
						});
						
						$('#combParag_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							/*if(q_cur==1 || q_cur==2){
								$('#txtParag_'+b_seq).val($('#combParag_'+b_seq).find("option:selected").text());
								//createImg(b_seq);
							}*/
						});
						
						$('#checkRadius_'+j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2){
								if($('#checkRadius_'+b_seq).prop('checked'))
									$('#txtRadius_'+b_seq).val(1);
								else
									$('#txtRadius_'+b_seq).val(0);
							}
							weighttotal();
						});
						
						$('#cmbMount2_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
							if($('#cmbMount2_'+b_seq).val()=='0'){
								$('#cmbScolor_'+b_seq).val('');
								$('#txtParaf_'+b_seq).val('');
								$('#txtParag_'+b_seq).val('');
							}else if($('#cmbMount2_'+b_seq).val()=='1'){
								if(emp($('#cmbScolor_'+b_seq).val())){
									$('#cmbScolor_'+b_seq).val('續接器-直牙');
									
									var t_size=dec(replaceAll($('#txtSize_'+b_seq).val(),'#',''));
									if(t_size<6){
										t_size='#6';
									}else{
										t_size=$('#txtSize_'+b_seq).val()
									}
									
									$('#txtParaf_'+b_seq).val(t_size+'公');
								}
								$('#txtParag_'+b_seq).val('');
							}else{
								if(emp($('#cmbScolor_'+b_seq).val())){
									$('#cmbScolor_'+b_seq).val('續接器-直牙');
									var t_size=dec(replaceAll($('#txtSize_'+b_seq).val(),'#',''));
									if(t_size<6){
										t_size='#6';
									}else{
										t_size=$('#txtSize_'+b_seq).val()
									}
									
									$('#txtParaf_'+b_seq).val(t_size+'公');
									$('#txtParag_'+b_seq).val(t_size+'母');
								}
							}
							change_parafg();
							weighttotal();
							splicertotal();
						});
						
						$('#checkHours_'+j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2){
								if($('#checkHours_'+b_seq).prop('checked'))
									$('#txtHours_'+b_seq).val(1);
								else
									$('#txtHours_'+b_seq).val(0);
							}
							weighttotal();
						});
						
						$('#checkWaste_'+j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2){
								if($('#checkWaste_'+b_seq).prop('checked'))
									$('#txtWaste_'+b_seq).val(1);
								else
									$('#txtWaste_'+b_seq).val(0);
							}
							weighttotal();
						});
						
						$('#checkMins_'+j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2){
								if($('#checkMins_'+b_seq).prop('checked'))
									$('#txtMins_'+b_seq).val(1);
								else
									$('#txtMins_'+b_seq).val(0);
							}
							weighttotal();
							splicertotal();
						});
						
						$('#txtPicno_' + j).bind('contextmenu', function(e) {
                            /*滑鼠右鍵*/
                            e.preventDefault();
                            var n = $(this).attr('id').replace('txtPicno_', '');
                            //$('#btnPicno_'+n).click();
                            
                            /*if($('#btnPic').val()=='成型參數顯示'){
								$('#btnPic').val('成型參數關閉');
								$('.pic').show();
								$('#tbbs').css("width","2350px");
								$('.dbbs').css("width","2350px");
							}*/
                        }).change(function() {
                        	t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
                        	if(emp($(this).val())){
                        		$('#txtPicname_'+b_seq).val('');
                        		$('#txtImgorg_'+b_seq).val('');
				                $('#txtImgdata_'+b_seq).val('');
				                $('#txtImgbarcode_'+b_seq).val('');
				                var c=document.getElementById("canvas_"+b_seq);
				                var cxt=c.getContext("2d");
				    			c.height=c.height;
				                $('#imgPic_'+b_seq).attr('src','');
                        	}
						});
                        
                        $('#txtParaa_'+j).change(function(e){
                    		var n = $(this).attr('id').replace('txtParaa_', '');
                    		createImg(n);
                    		
                    		/*var t_a=dec($('#txtParaa_'+n).val());
                    		var t_b=dec($('#txtParab_'+n).val());
                    		var t_c=dec($('#txtParac_'+n).val());
                    		var t_d=dec($('#txtParad_'+n).val());
                    		var t_e=dec($('#txtParae_'+n).val());
                    		$('#txtLengthb_'+n).val(round(q_add(q_add(q_add(q_add(t_a,t_b),t_c),t_d),t_e)/100,2));*/
                    	});
                    	$('#txtParab_'+j).change(function(e){
                    		var n = $(this).attr('id').replace('txtParab_', '');
                    		createImg(n);
                    		/*var t_a=dec($('#txtParaa_'+n).val());
                    		var t_b=dec($('#txtParab_'+n).val());
                    		var t_c=dec($('#txtParac_'+n).val());
                    		var t_d=dec($('#txtParad_'+n).val());
                    		var t_e=dec($('#txtParae_'+n).val());
                    		$('#txtLengthb_'+n).val(round(q_add(q_add(q_add(q_add(t_a,t_b),t_c),t_d),t_e)/100,2));*/
                    	});
                    	$('#txtParac_'+j).change(function(e){
                    		var n = $(this).attr('id').replace('txtParac_', '');
                    		createImg(n);
                    		/*var t_a=dec($('#txtParaa_'+n).val());
                    		var t_b=dec($('#txtParab_'+n).val());
                    		var t_c=dec($('#txtParac_'+n).val());
                    		var t_d=dec($('#txtParad_'+n).val());
                    		var t_e=dec($('#txtParae_'+n).val());
                    		$('#txtLengthb_'+n).val(round(q_add(q_add(q_add(q_add(t_a,t_b),t_c),t_d),t_e)/100,2));*/
                    	});
                    	$('#txtParad_'+j).change(function(e){
                    		var n = $(this).attr('id').replace('txtParad_', '');
                    		createImg(n);
                    		/*var t_a=dec($('#txtParaa_'+n).val());
                    		var t_b=dec($('#txtParab_'+n).val());
                    		var t_c=dec($('#txtParac_'+n).val());
                    		var t_d=dec($('#txtParad_'+n).val());
                    		var t_e=dec($('#txtParae_'+n).val());
                    		$('#txtLengthb_'+n).val(round(q_add(q_add(q_add(q_add(t_a,t_b),t_c),t_d),t_e)/100,2));*/
                    	});
                    	$('#txtParae_'+j).change(function(e){
                    		var n = $(this).attr('id').replace('txtParae_', '');
                    		createImg(n);
                    		/*var t_a=dec($('#txtParaa_'+n).val());
                    		var t_b=dec($('#txtParab_'+n).val());
                    		var t_c=dec($('#txtParac_'+n).val());
                    		var t_d=dec($('#txtParad_'+n).val());
                    		var t_e=dec($('#txtParae_'+n).val());
                    		$('#txtLengthb_'+n).val(round(q_add(q_add(q_add(q_add(t_a,t_b),t_c),t_d),t_e)/100,2));*/
                    	});
                    	$('#txtParaf_'+j).change(function(e){
                    		var n = $(this).attr('id').replace('txtParaf_', '');
                    		createImg(n);
                    		splicertotal();
                    	});
                    	$('#txtParag_'+j).change(function(e){
                    		var n = $(this).attr('id').replace('txtParag_', '');
                    		createImg(n);
                    		splicertotal();
                    	});
                    	
                    	$('#combParaf1_'+j).change(function() {
                    		t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							var t_para1=$('#combParaf1_'+b_seq).val();
							var t_para2=$('#combParaf2_'+b_seq).val();
                    		$('#txtParaf_'+b_seq).val(t_para1+t_para2);
                    		createImg(b_seq);
                    		change_parafg();
                    		splicertotal();
						});
						$('#combParaf2_'+j).change(function() {
                    		t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							var t_para1=$('#combParaf1_'+b_seq).val();
							var t_para2=$('#combParaf2_'+b_seq).val();
                    		$('#txtParaf_'+b_seq).val(t_para1+t_para2);
                    		createImg(b_seq);
                    		change_parafg();
                    		splicertotal();
						});
						$('#combParag1_'+j).change(function() {
                    		t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							var t_para1=$('#combParag1_'+b_seq).val();
							var t_para2=$('#combParag2_'+b_seq).val();
                    		$('#txtParag_'+b_seq).val(t_para1+t_para2);
                    		createImg(b_seq);
                    		change_parafg();
                    		splicertotal();
						});
						$('#combParag2_'+j).change(function() {
                    		t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							var t_para1=$('#combParag1_'+b_seq).val();
							var t_para2=$('#combParag2_'+b_seq).val();
                    		$('#txtParag_'+b_seq).val(t_para1+t_para2);
                    		createImg(b_seq);
                    		change_parafg();
                    		splicertotal();
						});
                    }
                }
                _bbsAssign();
                bbswidth();
                change_check();
                change_parafg();
                $('#lblOrdeno_s').text('訂單編號/訂序');
                $('#lblProduct_s').text('品名');
                $('#lblUcolor_s').text('類別');
                $('#lblSpec_s').text('材質');
                $('#lblSize_s').text('號數');
                $('#lblLengthb_s').text('長度(米)');
                $('#lblClass_s').text('廠牌');
                $('#lblUnit_s').text('單位');
                $('#lblMount1_s').text('支數');
                $('#lblMount_s').text('件數');
                $('#lblWeight_s').text('重量(KG)');
                $('#lblMemo_s').text('備註 (標籤)');
                $('#lblRadius_s').text('彎');
                $('#lblMins_s').text('裁剪完工');
                $('#lblWaste_s').text('成型完工');
                $('#lblHours_s').text('車牙完工');
                $('#vewNoa').text('案號');
                $('#vewCust').text('客戶');
                $('#vewMech').text('工地名稱');
                $('#lblSize2_s').text('工令');
                $('#lblStyle_s').text('加工型式');
				$('#lblMount2_s').text('車');
				$('#lblPic_s').text('形狀');
				$('#lblBtime_s').text('顏色1');
				$('#lblEtime_s').text('顏色2');
				$('#lblParaa_s').text('參數A');
				$('#lblParab_s').text('參數B');
				$('#lblParac_s').text('參數C');
				$('#lblParad_s').text('參數D');
				$('#lblParae_s').text('參數E');
				$('#lblParaf_s').text('續接參數F');
				$('#lblParag_s').text('續接參數G');
                
                //1117複製功能
                $('#btnProductCopy').click(function() {
                	if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtProduct_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#txtProduct_'+i).val())){
	                				$('#txtProduct_'+i).val($('#txtProduct_0').val());
	                			}
	                		}
                		}
                	}
				});
				
				$('#btnUcolorCopy').click(function() {
                	if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtUcolor_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#txtUcolor_'+i).val())){
	                				$('#txtUcolor_'+i).val($('#txtUcolor_0').val());
	                			}
	                		}
                		}
                	}
				});
				
				$('#btnSpecCopy').click(function() {
                	if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtSpec_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#txtSpec_'+i).val())){
	                				$('#txtSpec_'+i).val($('#txtSpec_0').val());
	                			}
	                		}
                		}
                	}
				});
				
				$('#btnSizeCopy').click(function() {
                	if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtSize_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#txtSize_'+i).val())){
	                				$('#txtSize_'+i).val($('#txtSize_0').val());
	                			}
	                		}
                		}
                	}
				});
				
				$('#btnClassCopy').click(function() {
                	if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtClass_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#txtClass_'+i).val())){
	                				$('#txtClass_'+i).val($('#txtClass_0').val());
	                			}
	                		}
                		}
                	}
				});
				
				$('#btnMemoCopy').click(function() {
                	if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtMemo_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#txtMemo_'+i).val())){
	                				$('#txtMemo_'+i).val($('#txtMemo_0').val());
	                			}
	                		}
                		}
                	}
				});
				
				$('#btnSize2Copy').click(function() {
                	if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtSize2_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#txtSize2_'+i).val())){
	                				$('#txtSize2_'+i).val($('#txtSize2_0').val());
	                			}
	                		}
                		}
                	}
				});
				
				//1124 新增
				$('#btnOrdeCopy').click(function() {
					if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtOrdeno_0').val())){
                			var t_no2='000';
	                		for (var i = 0; i < q_bbsCount; i++) {
	                			if(emp($('#txtOrdeno_'+i).val())){
	                				$('#txtOrdeno_'+i).val($('#txtOrdeno_0').val());
	                			}
	                			if($('#txtOrdeno_'+i).val()==$('#txtOrdeno_0').val() && !emp($('#txtNo2_'+i).val())){
	                				if(dec(t_no2)<dec($('#txtNo2_'+i).val()))
	                					t_no2=$('#txtNo2_'+i).val();
	                			}else if($('#txtOrdeno_'+i).val()==$('#txtOrdeno_0').val() && emp($('#txtNo2_'+i).val())){
	                				$('#txtNo2_'+i).val(('000'+(dec(t_no2)+1)).slice(-3));
	                				t_no2=$('#txtNo2_'+i).val();
	                			}
	                			
	                		}
                		}
                	}
				});
				
				$('#btnBtimeCopy').click(function() {
                	if(q_cur==1 || q_cur==2){
                		if(!emp($('#cmbBtime_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#cmbBtime_'+i).val())){
	                				$('#cmbBtime_'+i).val($('#cmbBtime_0').val());
	                			}
	                		}
                		}
                	}
				});
				
				$('#btnEtimeCopy').click(function() {
                	if(q_cur==1 || q_cur==2){
                		if(!emp($('#cmbEtime_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#cmbEtime_'+i).val())){
	                				$('#cmbEtime_'+i).val($('#cmbEtime_0').val());
	                			}
	                		}
                		}
                	}
				});
				
				for (var j = 0; j < q_bbsCount; j++) {
                	if($('#canvas_'+j).length>0){
						$('#imgPic_'+j).attr('src', $('#txtImgdata_'+j).val());
						showimg(j)
                	}
                }
            }
            
            //107/04/11 複製上一行資料
            function copybbspre(t_n){
            	if(!(q_cur==1 || q_cur==2)){
            		return;
            	}
            	
            	if(!(emp($('#txtUcolor_'+t_n).val()) && emp($('#txtSpec_'+t_n).val()) && emp($('#txtSize_'+t_n).val()))){
            		return;
            	}  
            	
            	var t_pn=(dec(t_n)-1);
            	if(dec(t_n)==0){
            		$('#txtOrdeno_'+t_n).val($('#txtNoa').val());
            		$('#txtNo2_'+t_n).val('001');
            	}else{
            		$('#txtOrdeno_'+t_n).val($('#txtNoa').val());
            		var t_no2=dec($('#txtNo2_'+t_pn).val())+1;
            		$('#txtNo2_'+t_n).val(('000'+t_no2.toString()).slice(-3));
            		$('#txtProduct_'+t_n).val($('#txtProduct_'+t_pn).val());
            		$('#txtUcolor_'+t_n).val($('#txtUcolor_'+t_pn).val());
            		$('#txtSpec_'+t_n).val($('#txtSpec_'+t_pn).val());
            		$('#txtSize_'+t_n).val($('#txtSize_'+t_pn).val());
            		$('#txtClass_'+t_n).val($('#txtClass_'+t_pn).val());
            		$('#cmbBtime_'+t_n).val($('#cmbBtime_'+t_pn).val());
            		$('#cmbEtime_'+t_n).val($('#cmbEtime_'+t_pn).val());
            		$('#txtMemo_'+t_n).val($('#txtMemo_'+t_pn).val());
            		$('#checkRadius_'+t_n).prop('checked',$('#checkRadius_'+t_pn).prop('checked'));
            		$('#txtRadius_'+t_n).val($('#txtRadius_'+t_pn).val());
            		$('#cmbMount2_'+t_n).val($('#cmbMount2_'+t_pn).val());
            		$('#txtPicno_'+t_n).val($('#txtPicno_'+t_pn).val());
            		$('#txtPicname_'+t_n).val($('#txtPicname_'+t_pn).val());
            		$('#txtPara_'+t_n).val($('#txtPara_'+t_pn).val());
            		$('#imgPic_'+t_n).attr("src",$('#imgPic_'+t_pn).attr("src"));
            		$('#txtImgorg_'+t_n).val($('#txtImgorg_'+t_pn).val());
            		$('#txtImgdata_'+t_n).val($('#txtImgdata_'+t_pn).val());
            		$('#txtImgbarcode_'+t_n).val($('#txtImgbarcode_'+t_pn).val());
            		$('#txtSize2_'+t_n).val($('#txtSize2_'+t_pn).val());
            		$('#txtParaa_'+t_n).val($('#txtParaa_'+t_pn).val());
            		$('#txtParab_'+t_n).val($('#txtParab_'+t_pn).val());
            		$('#txtParac_'+t_n).val($('#txtParac_'+t_pn).val());
            		$('#txtParad_'+t_n).val($('#txtParad_'+t_pn).val());
            		$('#txtParae_'+t_n).val($('#txtParae_'+t_pn).val());
            		$('#txtParaf_'+t_n).val($('#txtParaf_'+t_pn).val());
            		$('#txtParag_'+t_n).val($('#txtParag_'+t_pn).val());
            		$('#cmbScolor_'+t_n).val($('#cmbScolor_'+t_pn).val());
            	}
            	change_parafg();
            }
            
            function showimg(n){
            	var image = document.getElementById('imgPic_'+n);
            	image.onload = function() {
					var imgwidth = $('#imgPic_'+n).width();
	                var imgheight = $('#imgPic_'+n).height();
	                if($("#canvas_"+n)[0]!=undefined)
						$("#canvas_"+n)[0].getContext("2d").drawImage($('#imgPic_'+n)[0],0,0,imgwidth,imgheight,0,0,150,50);
				}
            }
            
            function bbsweight(n) {
            	if(!(q_cur==1 || q_cur==2)){
            		return;
            	}
            	var t_siez=replaceAll($('#txtSize_'+n).val(),'#','');
            	var t_weight=0;
            	switch(t_siez){
            		case '3': t_weight=0.560; break;
            		case '4': t_weight=0.994; break;
            		case '5': t_weight=1.560; break;
            		case '6': t_weight=2.250; break;
            		case '7': t_weight=3.040; break;
            		case '8': t_weight=3.980; break;
            		case '9': t_weight=5.080; break;
            		case '10': t_weight=6.390; break;
            		case '11': t_weight=7.900; break;
            		case '12': t_weight=9.570; break;
            		case '14': t_weight=11.40; break;
            		case '16': t_weight=15.50; break;
            		case '18': t_weight=20.20; break;
            	}
            	
            	var t_lengthb=dec($('#txtLengthb_'+n).val());
            	var t_mount1=dec($('#txtMount1_'+n).val());
            	
            	$('#txtWeight_'+n).val(round(q_mul(q_mul(t_weight,t_lengthb),t_mount1),0));
            	weighttotal()
            }
            
            function weighttotal() {
            	var t_weight=0;
            	for (var j = 0; j < q_bbsCount; j++) {
            		t_weight=q_add(t_weight,dec($('#txtWeight_'+j).val()));
            	}
            	$('#textWeight').val(FormatNumber(t_weight));
            	
            	var t_weight1=0; //直
            	var t_weight2=0; //彎
            	var t_weight3=0; //牙
            	var t_weight4=0; //牙數
            	for (var j = 0; j < q_bbsCount; j++) {
            		if($('#checkRadius_'+j).prop('checked')){
            			t_weight2=q_add(t_weight2,dec($('#txtWeight_'+j).val()));
            		}
            		if(dec($('#cmbMount2_'+j).val())>0){
            			t_weight3=q_add(t_weight3,dec($('#txtWeight_'+j).val()));
            			t_weight4=q_add(t_weight4,q_mul(dec($('#cmbMount2_'+j).val()),dec($('#txtMount1_'+j).val())));
            		}
            		if(!$('#checkRadius_'+j).prop('checked') && dec($('#cmbMount2_'+j).val())==0){
            			t_weight1=q_add(t_weight1,dec($('#txtWeight_'+j).val()));
            		}
            	}
            	$('#textWeight1').val(FormatNumber(t_weight1));
            	$('#textWeight2').val(FormatNumber(t_weight2));
            	$('#textWeight3').val(FormatNumber(t_weight3));
            	$('#textWeight4').val(FormatNumber(t_weight4));
            	
            	var t_s2_3=0,t_s2_4=0,t_s2_5=0,t_s2_6=0,t_s2_7=0,t_s2_8=0,t_s2_9=0,t_s2_10=0,t_s2_11=0,t_s2_12=0;
            	var t_s2w_3=0,t_s2w_4=0,t_s2w_5=0,t_s2w_6=0,t_s2w_7=0,t_s2w_8=0,t_s2w_9=0,t_s2w_10=0,t_s2w_11=0,t_s2w_12=0;
            	var t_s4w_3=0,t_s4w_4=0,t_s4w_5=0,t_s4w_6=0,t_s4w_7=0,t_s4w_8=0,t_s4w_9=0,t_s4w_10=0,t_s4w_11=0,t_s4w_12=0;
            	
            	for (var j = 0; j < q_bbsCount; j++) {
            		var t_size=$.trim($('#txtSize_'+j).val());
            		var t_spec=$.trim($('#txtSpec_'+j).val());
            		
            		switch(t_size) {
	                	case '#3':
	                		if(t_spec=='SD280'){
	                			t_s2_3=q_add(t_s2_3,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD280W'){
	                			t_s2w_3=q_add(t_s2w_3,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD420W'){
	                			t_s4w_3=q_add(t_s4w_3,dec($('#txtWeight_'+j).val()));
	                		}
	                		break;
	                	case '#4':
	                		if(t_spec=='SD280'){
	                			t_s2_4=q_add(t_s2_4,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD280W'){
	                			t_s2w_4=q_add(t_s2w_4,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD420W'){
	                			t_s4w_4=q_add(t_s4w_4,dec($('#txtWeight_'+j).val()));
	                		}
	                		break;
	                	case '#5':
	                		if(t_spec=='SD280'){
	                			t_s2_5=q_add(t_s2_5,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD280W'){
	                			t_s2w_5=q_add(t_s2w_5,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD420W'){
	                			t_s4w_5=q_add(t_s4w_5,dec($('#txtWeight_'+j).val()));
	                		}
	                		break;
	                	case '#6':
	                		if(t_spec=='SD280'){
	                			t_s2_6=q_add(t_s2_6,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD280W'){
	                			t_s2w_6=q_add(t_s2w_6,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD420W'){
	                			t_s4w_6=q_add(t_s4w_6,dec($('#txtWeight_'+j).val()));
	                		}
	                		break;
	                	case '#7':
	                		if(t_spec=='SD280'){
	                			t_s2_7=q_add(t_s2_7,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD280W'){
	                			t_s2w_7=q_add(t_s2w_7,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD420W'){
	                			t_s4w_7=q_add(t_s4w_7,dec($('#txtWeight_'+j).val()));
	                		}
	                		break;
	                	case '#8':
	                		if(t_spec=='SD280'){
	                			t_s2_8=q_add(t_s2_8,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD280W'){
	                			t_s2w_8=q_add(t_s2w_8,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD420W'){
	                			t_s4w_8=q_add(t_s4w_8,dec($('#txtWeight_'+j).val()));
	                		}
	                		break;
	                	case '#9':
	                		if(t_spec=='SD280'){
	                			t_s2_9=q_add(t_s2_9,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD280W'){
	                			t_s2w_9=q_add(t_s2w_9,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD420W'){
	                			t_s4w_9=q_add(t_s4w_9,dec($('#txtWeight_'+j).val()));
	                		}
	                		break;
	                	case '#10':
	                		if(t_spec=='SD280'){
	                			t_s2_10=q_add(t_s2_10,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD280W'){
	                			t_s2w_10=q_add(t_s2w_10,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD420W'){
	                			t_s4w_10=q_add(t_s4w_10,dec($('#txtWeight_'+j).val()));
	                		}
	                		break;
	                	case '#11':
	                		if(t_spec=='SD280'){
	                			t_s2_11=q_add(t_s2_11,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD280W'){
	                			t_s2w_11=q_add(t_s2w_11,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD420W'){
	                			t_s4w_11=q_add(t_s4w_11,dec($('#txtWeight_'+j).val()));
	                		}
	                		break;
	                	case '#12':
	                		if(t_spec=='SD280'){
	                			t_s2_12=q_add(t_s2_12,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD280W'){
	                			t_s2w_12=q_add(t_s2w_12,dec($('#txtWeight_'+j).val()));
	                		}else if(t_spec=='SD420W'){
	                			t_s4w_12=q_add(t_s4w_12,dec($('#txtWeight_'+j).val()));
	                		}
	                		break;
	                }
            	}
            	$('#S2_3').text(t_s2_3);
            	$('#S2_4').text(t_s2_4);
            	$('#S2_5').text(t_s2_5);
            	$('#S2_6').text(t_s2_6);
            	$('#S2_7').text(t_s2_7);
            	$('#S2_8').text(t_s2_8);
            	$('#S2_9').text(t_s2_9);
            	$('#S2_10').text(t_s2_10);
            	$('#S2_11').text(t_s2_11);
            	$('#S2_12').text(t_s2_12);
            	//-----------------------
            	$('#S2W_3').text(t_s2w_3);
            	$('#S2W_4').text(t_s2w_4);
            	$('#S2W_5').text(t_s2w_5);
            	$('#S2W_6').text(t_s2w_6);
            	$('#S2W_7').text(t_s2w_7);
            	$('#S2W_8').text(t_s2w_8);
            	$('#S2W_9').text(t_s2w_9);
            	$('#S2W_10').text(t_s2w_10);
            	$('#S2W_11').text(t_s2w_11);
            	$('#S2W_12').text(t_s2w_12);
            	//------------------------
            	$('#S4W_3').text(t_s4w_3);
            	$('#S4W_4').text(t_s4w_4);
            	$('#S4W_5').text(t_s4w_5);
            	$('#S4W_6').text(t_s4w_6);
            	$('#S4W_7').text(t_s4w_7);
            	$('#S4W_8').text(t_s4w_8);
            	$('#S4W_9').text(t_s4w_9);
            	$('#S4W_10').text(t_s4w_10);
            	$('#S4W_11').text(t_s4w_11);
            	$('#S4W_12').text(t_s4w_12);
			}
			
            function btnIns() {
                _btnIns();
                //$('#txtNoa').val('AUTO');
                $('#txtDatea').val(q_date()).focus();
                refreshBbm();
                $('#txtTypea').val('鋼筋');
                $('#dbbssplicer').hide();
                $('#splicertotal').hide();
                $('.dbbs').show();
                splicerdiv=false;
                
                for (var i = 0; i < q_bbsCount; i++) {
                	$('#txtOrdeno_'+i).val('');
                	$('#checkMins_'+i).prop('checked',false);
                	$('#checkWaste_'+i).prop('checked',false);
                	$('#checkHours_'+i).prop('checked',false);
                	$('#txtMins_'+i).val('0');
                	$('#txtWaste_'+i).val('0');
                	$('#txtHours_'+i).val('0');
                }
            }

            function btnModi() {
                if (emp($('#txtNoa').val()))
                    return;
                _btnModi();
                refreshBbm();
                if(!emp($('#txtCustno').val())){
					q_gt('custms', "where=^^noa='"+$('#txtCustno').val()+"'^^ ", 0, 0, 0, "custms");	
				}
            }

            function btnPrint() {
				var t_where = "noa='" + $.trim($('#txtNoa').val()) + "'";
               	q_box("z_cucp_vu.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, '', "95%", "95%", q_getMsg('popPrint'));
            }

            function wrServer(key_value) {
                var i;

                $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
                _btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
            }

            function bbsSave(as) {
                if (!as['ordeno'] && !as['spec'] && !as['size'] && !as['ucolor']) {
                    as[bbsKey[1]] = '';
                    return;
                }

                q_nowf();

                return true;
            }

            ///////////////////////////////////////////////////  以下提供事件程式，有需要時修改
            function refresh(recno) {
                _refresh(recno);
                change_check();
                change_parafg();
                weighttotal();
                splicertotal();
                refreshBbm();
                comb_disabled();
                $('#dbbssplicer').hide();
                $('#splicertotal').hide();
                $('.dbbs').show();
                splicerdiv=false;
                
                if(!emp($('#txtCustno').val())){
					q_gt('custms', "where=^^noa='"+$('#txtCustno').val()+"'^^ ", 0, 0, 0, "custms");
				}
            }

            function readonly(t_para, empty) {
                _readonly(t_para, empty);
                change_check();
                change_parafg();
                if(t_para){
                	$('#txtDatea').datepicker('destroy');
                	$('#txtBdate').datepicker('destroy');
                }else{
                	$('#txtDatea').datepicker();
                	$('#txtBdate').datepicker();
                }
                comb_disabled();
            }
            
            function refreshBbm() {
                if (q_cur == 1) {
                    $('#txtNoa').css('color', 'black').css('background', 'white').removeAttr('readonly');
                } else {
                    $('#txtNoa').css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
                }
                
            }

            function btnMinus(id) {
                _btnMinus(id);
                var n=id.split('_')[1];
                $('#txtImgorg_'+n).val('');
                $('#txtImgdata_'+n).val('');
                $('#txtImgbarcode_'+n).val('');
                var c=document.getElementById("canvas_"+n);
                var cxt=c.getContext("2d");
    			c.height=c.height;
                $('#imgPic_'+n).attr('src','');
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
            
            function comb_disabled() {
            	if(q_cur==1 || q_cur==2){
            		$('.comb').removeAttr('disabled');
                }else{
                	$('.comb').attr('disabled', 'disabled');
                }
            }
            
            function change_check() {
            	if(q_cur==1 || q_cur==2){
            		$('#checkGen').removeAttr('disabled');
            	}else{
            		$('#checkGen').attr('disabled', 'disabled');
            	}
            	if($('#txtGen').val()==0){
					$('#checkGen').prop('checked',false);
				}else{
					$('#checkGen').prop('checked',true);
				}
            	
				for (var i = 0; i < q_bbsCount; i++) {
					if(q_cur==1 || q_cur==2){
						$('#checkMins_'+i).removeAttr('disabled');
						$('#checkRadius_'+i).removeAttr('disabled');
						$('#checkHours_'+i).removeAttr('disabled');
						$('#checkWaste_'+i).removeAttr('disabled');
					}else{
						$('#checkMins_'+i).attr('disabled', 'disabled');
						$('#checkRadius_'+i).attr('disabled', 'disabled');
						$('#checkHours_'+i).attr('disabled', 'disabled');
						$('#checkWaste_'+i).attr('disabled', 'disabled');
					}
					if($('#txtMins_'+i).val()==0){
						$('#checkMins_'+i).prop('checked',false);
					}else{
						$('#checkMins_'+i).prop('checked',true);
					}
					if($('#txtRadius_'+i).val()==0){
						$('#checkRadius_'+i).prop('checked',false);
					}else{
						$('#checkRadius_'+i).prop('checked',true);
					}
					if($('#txtHours_'+i).val()==0){
						$('#checkHours_'+i).prop('checked',false);
					}else{
						$('#checkHours_'+i).prop('checked',true);
					}
					if($('#txtWaste_'+i).val()==0){
						$('#checkWaste_'+i).prop('checked',false);
					}else{
						$('#checkWaste_'+i).prop('checked',true);
					}
				}
			}
			
			function change_parafg() {
				for (var i = 0; i < q_bbsCount; i++) {
					if(!emp($('#txtParaf_'+i).val())){
						var t_paraf=$.trim($('#txtParaf_'+i).val());
						var tpara1=replaceAll(replaceAll(replaceAll(t_paraf,'公',''),'母',''),'T','');
						var tpara2=t_paraf.substr(tpara1.length);
						$('#combParaf1_'+i).val(tpara1);
						$('#combParaf2_'+i).val(tpara2);
					}else{
						$('#combParaf1_'+i).val('');
						$('#combParaf2_'+i).val('');
					}
					if(!emp($('#txtParag_'+i).val())){
						var t_parag=$.trim($('#txtParag_'+i).val());
						var tpara1=replaceAll(replaceAll(replaceAll(t_parag,'公',''),'母',''),'T','');
						var tpara2=t_parag.substr(tpara1.length);
						$('#combParag1_'+i).val(tpara1);
						$('#combParag2_'+i).val(tpara2);
					}else{
						$('#combParag1_'+i).val('');
						$('#combParag2_'+i).val('');
					}
				}
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
			
			function bbswidth() {
				var t_width=1750; //預設寬度
				if($('#btnShowpara').val()=='參數關閉'){ //成型參數顯示
					t_width=t_width+850;
					$('.para').show();
				}else{
					$('.para').hide();
				}
				$('#tbbs').css("width",t_width+"px");
				$('.dbbs').css("width",t_width+"px");				
			}
			
			function splicertotal() {
				var t_sp1_6=0,t_sp1_6w=0,t_sp1_7=0,t_sp1_7w=0,t_sp1_8=0,t_sp1_8w=0,t_sp1_9=0,t_sp1_9w=0,t_sp1_10=0,t_sp1_10w=0,t_sp1_11=0,t_sp1_11w=0,t_sp1_12=0,t_sp1_12w=0;
				var t_sp2_6=0,t_sp2_6w=0,t_sp2_7=0,t_sp2_7w=0,t_sp2_8=0,t_sp2_8w=0,t_sp2_9=0,t_sp2_9w=0,t_sp2_10=0,t_sp2_10w=0,t_sp2_11=0,t_sp2_11w=0,t_sp2_12=0,t_sp2_12w=0;
				var t_sp3_6=0,t_sp3_6w=0,t_sp3_7=0,t_sp3_7w=0,t_sp3_8=0,t_sp3_8w=0,t_sp3_9=0,t_sp3_9w=0,t_sp3_10=0,t_sp3_10w=0,t_sp3_11=0,t_sp3_11w=0,t_sp3_12=0,t_sp3_12w=0;
				var t_sp4_6=0,t_sp4_6w=0,t_sp4_7=0,t_sp4_7w=0,t_sp4_8=0,t_sp4_8w=0,t_sp4_9=0,t_sp4_9w=0,t_sp4_10=0,t_sp4_10w=0,t_sp4_11=0,t_sp4_11w=0,t_sp4_12=0,t_sp4_12w=0;
				var t_sp5_6=0,t_sp5_6w=0,t_sp5_7=0,t_sp5_7w=0,t_sp5_8=0,t_sp5_8w=0,t_sp5_9=0,t_sp5_9w=0,t_sp5_10=0,t_sp5_10w=0,t_sp5_11=0,t_sp5_11w=0,t_sp5_12=0,t_sp5_12w=0;
				var t_spt_6=0,t_spt_6w=0,t_spt_7=0,t_spt_7w=0,t_spt_8=0,t_spt_8w=0,t_spt_9=0,t_spt_9w=0,t_spt_10=0,t_spt_10w=0,t_spt_11=0,t_spt_11w=0,t_spt_12=0,t_spt_12w=0;
				
				for (var j = 0; j < q_bbsCount; j++) {
					var t_mount=dec($('#txtMount1_'+j).val());
            		var t_scolor=$.trim($('#cmbScolor_'+j).val());
            		var t_mount2=dec($('#cmbMount2_'+j).val());
            		if(t_scolor.length>0 && t_mount2>0){
	            		var t_paraf1=$.trim(replaceAll(replaceAll(replaceAll($('#txtParaf_'+j).val(),'公',''),'母',''),'T',''));
	            		var t_paraf2=$.trim(replaceAll($('#txtParaf_'+j).val(),t_paraf1,''));
	            		var t_parag1=$.trim(replaceAll(replaceAll(replaceAll($('#txtParag_'+j).val(),'公',''),'母',''),'T',''));
	            		var t_parag2=$.trim(replaceAll($('#txtParag_'+j).val(),t_parag1,''));
	            		
	            		switch(t_scolor) {
		                	case '續接器-直牙':
		                		if(t_paraf2=='公'){
		                			if(t_paraf1=='#6'){
		                				t_sp1_6=q_add(t_sp1_6,t_mount);
		                				t_sp1_6w=q_add(t_sp1_6w,round(t_mount*0.084,3));
		                			}else if(t_paraf1=='#7'){
		                				t_sp1_7=q_add(t_sp1_7,t_mount);
		                				t_sp1_7w=q_add(t_sp1_7w,round(t_mount*0.124,3));
		                			}else if(t_paraf1=='#8'){
		                				t_sp1_8=q_add(t_sp1_8,t_mount);
		                				t_sp1_8w=q_add(t_sp1_8w,round(t_mount*0.178,3));
		                			}else if(t_paraf1=='#9'){
		                				t_sp1_9=q_add(t_sp1_9,t_mount);
		                			}else if(t_paraf1=='#10'){
		                				t_sp1_10=q_add(t_sp1_10,t_mount);
		                				t_sp1_10w=q_add(t_sp1_10w,round(t_mount*0.361,3));
		                			}else if(t_paraf1=='#11'){
		                				t_sp1_11=q_add(t_sp1_11,t_mount);
		                				t_sp1_11w=q_add(t_sp1_11w,round(t_mount*0.532,3));
		                			}else if(t_paraf1=='#12'){
		                				t_sp1_12=q_add(t_sp1_12,t_mount);
		                			}
		                		}else if(t_paraf2=='母'){
		                			if(t_paraf1=='#6'){
		                				t_sp2_6=q_add(t_sp2_6,t_mount);
		                				t_sp2_6w=q_add(t_sp2_6w,round(t_mount*0.107,3));
		                			}else if(t_paraf1=='#7'){
		                				t_sp2_7=q_add(t_sp2_7,t_mount);
		                				t_sp2_7w=q_add(t_sp2_7w,round(t_mount*0.136,3));
		                			}else if(t_paraf1=='#8'){
		                				t_sp2_8=q_add(t_sp2_8,t_mount);
		                				t_sp2_8w=q_add(t_sp2_8w,round(t_mount*0.205,3));
		                			}else if(t_paraf1=='#9'){
		                				t_sp2_9=q_add(t_sp2_9,t_mount);
		                			}else if(t_paraf1=='#10'){
		                				t_sp2_10=q_add(t_sp2_10,t_mount);
		                				t_sp2_10w=q_add(t_sp2_10w,round(t_mount*0.407,3));
		                			}else if(t_paraf1=='#11'){
		                				t_sp2_11=q_add(t_sp2_11,t_mount);
		                				t_sp2_11w=q_add(t_sp2_11w,round(t_mount*0.489,3));
		                			}else if(t_paraf1=='#12'){
		                				t_sp2_12=q_add(t_sp2_12,t_mount);
		                			}
		                		}
		                		//------------------------------------------
		                		if(t_parag2=='公'){
		                			if(t_parag1=='#6'){
		                				t_sp1_6=q_add(t_sp1_6,t_mount);
		                				t_sp1_6w=q_add(t_sp1_6w,round(t_mount*0.084,3));
		                			}else if(t_parag1=='#7'){
		                				t_sp1_7=q_add(t_sp1_7,t_mount);
		                				t_sp1_7w=q_add(t_sp1_7w,round(t_mount*0.124,3));
		                			}else if(t_parag1=='#8'){
		                				t_sp1_8=q_add(t_sp1_8,t_mount);
		                				t_sp1_8w=q_add(t_sp1_8w,round(t_mount*0.178,3));
		                			}else if(t_parag1=='#9'){
		                				t_sp1_9=q_add(t_sp1_9,t_mount);
		                			}else if(t_parag1=='#10'){
		                				t_sp1_10=q_add(t_sp1_10,t_mount);
		                				t_sp1_10w=q_add(t_sp1_10w,round(t_mount*0.361,3));
		                			}else if(t_parag1=='#11'){
		                				t_sp1_11=q_add(t_sp1_11,t_mount);
		                				t_sp1_11w=q_add(t_sp1_11w,round(t_mount*0.532,3));
		                			}else if(t_parag1=='#12'){
		                				t_sp1_12=q_add(t_sp1_12,t_mount);
		                			}
		                		}else if(t_parag2=='母'){
		                			if(t_parag1=='#6'){
		                				t_sp2_6=q_add(t_sp2_6,t_mount);
		                				t_sp2_6w=q_add(t_sp2_6w,round(t_mount*0.107,3));
		                			}else if(t_parag1=='#7'){
		                				t_sp2_7=q_add(t_sp2_7,t_mount);
		                				t_sp2_7w=q_add(t_sp2_7w,round(t_mount*0.136,3));
		                			}else if(t_parag1=='#8'){
		                				t_sp2_8=q_add(t_sp2_8,t_mount);
		                				t_sp2_8w=q_add(t_sp2_8w,round(t_mount*0.205,3));
		                			}else if(t_parag1=='#9'){
		                				t_sp2_9=q_add(t_sp2_9,t_mount);
		                			}else if(t_parag1=='#10'){
		                				t_sp2_10=q_add(t_sp2_10,t_mount);
		                				t_sp2_10w=q_add(t_sp2_10w,round(t_mount*0.407,3));
		                			}else if(t_parag1=='#11'){
		                				t_sp2_11=q_add(t_sp2_11,t_mount);
		                				t_sp2_11w=q_add(t_sp2_11w,round(t_mount*0.489,3));
		                			}else if(t_parag1=='#12'){
		                				t_sp2_12=q_add(t_sp2_12,t_mount);
		                			}
		                		}
		                		break;
		                	case '續接器-錐牙':
		                		if(t_paraf2=='公'){
		                			if(t_paraf1=='#6'){
		                				t_sp3_6=q_add(t_sp3_6,t_mount);
		                				t_sp3_6w=q_add(t_sp3_6w,round(t_mount*0.084,3));
		                			}else if(t_paraf1=='#7'){
		                				t_sp3_7=q_add(t_sp3_7,t_mount);
		                				t_sp3_7w=q_add(t_sp3_7w,round(t_mount*0.124,3));
		                			}else if(t_paraf1=='#8'){
		                				t_sp3_8=q_add(t_sp3_8,t_mount);
		                				t_sp3_8w=q_add(t_sp3_8w,round(t_mount*0.172,3));
		                			}else if(t_paraf1=='#9'){
		                				t_sp3_9=q_add(t_sp3_9,t_mount);
		                			}else if(t_paraf1=='#10'){
		                				t_sp3_10=q_add(t_sp3_10,t_mount);
		                				t_sp3_10w=q_add(t_sp3_10w,round(t_mount*0.323,3));
		                			}else if(t_paraf1=='#11'){
		                				t_sp3_11=q_add(t_sp3_11,t_mount);
		                				t_sp3_11w=q_add(t_sp3_11w,round(t_mount*0.445,3));
		                			}else if(t_paraf1=='#12'){
		                				t_sp3_12=q_add(t_sp3_12,t_mount);
		                			}
		                		}else if(t_paraf2=='母'){
		                			if(t_paraf1=='#6'){
		                				t_sp4_6=q_add(t_sp4_6,t_mount);
		                				t_sp4_6w=q_add(t_sp4_6w,round(t_mount*0.095,3));
		                			}else if(t_paraf1=='#7'){
		                				t_sp4_7=q_add(t_sp4_7,t_mount);
		                				t_sp4_7w=q_add(t_sp4_7w,round(t_mount*0.131,3));
		                			}else if(t_paraf1=='#8'){
		                				t_sp4_8=q_add(t_sp4_8,t_mount);
		                				t_sp4_8w=q_add(t_sp4_8w,round(t_mount*0.188,3));
		                			}else if(t_paraf1=='#9'){
		                				t_sp4_9=q_add(t_sp4_9,t_mount);
		                			}else if(t_paraf1=='#10'){
		                				t_sp4_10=q_add(t_sp4_10,t_mount);
		                				t_sp4_10w=q_add(t_sp4_10w,round(t_mount*0.347,3));
		                			}else if(t_paraf1=='#11'){
		                				t_sp4_11=q_add(t_sp4_11,t_mount);
		                				t_sp4_11w=q_add(t_sp4_11w,round(t_mount*0.496,3));
		                			}else if(t_paraf1=='#12'){
		                				t_sp4_12=q_add(t_sp4_12,t_mount);
		                			}
		                		}
		                		//------------------------------------------
		                		if(t_parag2=='公'){
		                			if(t_parag1=='#6'){
		                				t_sp3_6=q_add(t_sp3_6,t_mount);
		                				t_sp3_6w=q_add(t_sp3_6w,round(t_mount*0.084,3));
		                			}else if(t_parag1=='#7'){
		                				t_sp3_7=q_add(t_sp3_7,t_mount);
		                				t_sp3_7w=q_add(t_sp3_7w,round(t_mount*0.124,3));
		                			}else if(t_parag1=='#8'){
		                				t_sp3_8=q_add(t_sp3_8,t_mount);
		                				t_sp3_8w=q_add(t_sp3_8w,round(t_mount*0.172,3));
		                			}else if(t_parag1=='#9'){
		                				t_sp3_9=q_add(t_sp3_9,t_mount);
		                			}else if(t_parag1=='#10'){
		                				t_sp3_10=q_add(t_sp3_10,t_mount);
		                				t_sp3_10w=q_add(t_sp3_10w,round(t_mount*0.323,3));
		                			}else if(t_parag1=='#11'){
		                				t_sp3_11=q_add(t_sp3_11,t_mount);
		                				t_sp3_11w=q_add(t_sp3_11w,round(t_mount*0.445,3));
		                			}else if(t_parag1=='#12'){
		                				t_sp3_12=q_add(t_sp3_12,t_mount);
		                			}
		                		}else if(t_parag2=='母'){
		                			if(t_parag1=='#6'){
		                				t_sp4_6=q_add(t_sp4_6,t_mount);
		                				t_sp4_6w=q_add(t_sp4_6w,round(t_mount*0.095,3));
		                			}else if(t_parag1=='#7'){
		                				t_sp4_7=q_add(t_sp4_7,t_mount);
		                				t_sp4_7w=q_add(t_sp4_7w,round(t_mount*0.131,3));
		                			}else if(t_parag1=='#8'){
		                				t_sp4_8=q_add(t_sp4_8,t_mount);
		                				t_sp4_8w=q_add(t_sp4_8w,round(t_mount*0.188,3));
		                			}else if(t_parag1=='#9'){
		                				t_sp4_9=q_add(t_sp4_9,t_mount);
		                			}else if(t_parag1=='#10'){
		                				t_sp4_10=q_add(t_sp4_10,t_mount);
		                				t_sp4_10w=q_add(t_sp4_10w,round(t_mount*0.347,3));
		                			}else if(t_parag1=='#11'){
		                				t_sp4_11=q_add(t_sp4_11,t_mount);
		                				t_sp4_11w=q_add(t_sp4_11w,round(t_mount*0.496,3));
		                			}else if(t_parag1=='#12'){
		                				t_sp4_12=q_add(t_sp4_12,t_mount);
		                			}
		                		}
		                		break;
		                	case '續接器-T頭':
		                		if(t_paraf2=='T'){
		                			if(t_paraf1=='#6'){
		                				t_sp5_6=q_add(t_sp5_6,t_mount);
		                				t_sp5_6w=q_add(t_sp5_6w,round(t_mount*0.231,3));
		                			}else if(t_paraf1=='#7'){
		                				t_sp5_7=q_add(t_sp5_7,t_mount);
		                				t_sp5_7w=q_add(t_sp5_7w,round(t_mount*0.361,3));
		                			}else if(t_paraf1=='#8'){
		                				t_sp5_8=q_add(t_sp5_8,t_mount);
		                				t_sp5_8w=q_add(t_sp5_8w,round(t_mount*0.547,3));
		                			}else if(t_paraf1=='#9'){
		                				t_sp5_9=q_add(t_sp5_9,t_mount);
		                			}else if(t_paraf1=='#10'){
		                				t_sp5_10=q_add(t_sp5_10,t_mount);
		                				t_sp5_10w=q_add(t_sp5_10w,round(t_mount*1.024,3));
		                			}else if(t_paraf1=='#11'){
		                				t_sp5_11=q_add(t_sp5_11,t_mount);
		                			}else if(t_paraf1=='#12'){
		                				t_sp5_12=q_add(t_sp5_12,t_mount);
		                			}
		                		}
		                		//------------------------------------------
		                		if(t_parag2=='T'){
		                			if(t_parag1=='#6'){
		                				t_sp5_6=q_add(t_sp5_6,t_mount);
		                				t_sp5_6w=q_add(t_sp5_6w,round(t_mount*0.231,3));
		                			}else if(t_parag1=='#7'){
		                				t_sp5_7=q_add(t_sp5_7,t_mount);
		                				t_sp5_7w=q_add(t_sp5_7w,round(t_mount*0.361,3));
		                			}else if(t_parag1=='#8'){
		                				t_sp5_8=q_add(t_sp5_8,t_mount);
		                				t_sp5_8w=q_add(t_sp5_8w,round(t_mount*0.547,3));
		                			}else if(t_parag1=='#9'){
		                				t_sp5_9=q_add(t_sp5_9,t_mount);
		                			}else if(t_parag1=='#10'){
		                				t_sp5_10=q_add(t_sp5_10,t_mount);
		                				t_sp5_10w=q_add(t_sp5_10w,round(t_mount*1.024,3));
		                			}else if(t_parag1=='#11'){
		                				t_sp5_11=q_add(t_sp5_11,t_mount);
		                			}else if(t_parag1=='#12'){
		                				t_sp5_12=q_add(t_sp5_12,t_mount);
		                			}
		                		}
		                		break;
		                }
					}
				}
				t_spt_6=q_add(q_add(q_add(q_add(t_sp1_6,t_sp2_6),t_sp3_6),t_sp4_6),t_sp5_6);
				t_spt_7=q_add(q_add(q_add(q_add(t_sp1_7,t_sp2_7),t_sp3_7),t_sp4_7),t_sp5_7);
				t_spt_8=q_add(q_add(q_add(q_add(t_sp1_8,t_sp2_8),t_sp3_8),t_sp4_8),t_sp5_8);
				t_spt_9=q_add(q_add(q_add(q_add(t_sp1_9,t_sp2_9),t_sp3_9),t_sp4_9),t_sp5_9);
				t_spt_10=q_add(q_add(q_add(q_add(t_sp1_10,t_sp2_10),t_sp3_10),t_sp4_10),t_sp5_10);
				t_spt_11=q_add(q_add(q_add(q_add(t_sp1_11,t_sp2_11),t_sp3_11),t_sp4_11),t_sp5_11);
				t_spt_12=q_add(q_add(q_add(q_add(t_sp1_12,t_sp2_12),t_sp3_12),t_sp4_12),t_sp5_12);
				t_spt_6w=q_add(q_add(q_add(q_add(t_sp1_6w,t_sp2_6w),t_sp3_6w),t_sp4_6w),t_sp5_6w);
				t_spt_7w=q_add(q_add(q_add(q_add(t_sp1_7w,t_sp2_7w),t_sp3_7w),t_sp4_7w),t_sp5_7w);
				t_spt_8w=q_add(q_add(q_add(q_add(t_sp1_8w,t_sp2_8w),t_sp3_8w),t_sp4_8w),t_sp5_8w);
				t_spt_9w=q_add(q_add(q_add(q_add(t_sp1_9w,t_sp2_9w),t_sp3_9w),t_sp4_9w),t_sp5_9w);
				t_spt_10w=q_add(q_add(q_add(q_add(t_sp1_10w,t_sp2_10w),t_sp3_10w),t_sp4_10w),t_sp5_10w);
				t_spt_11w=q_add(q_add(q_add(q_add(t_sp1_11w,t_sp2_11w),t_sp3_11w),t_sp4_11w),t_sp5_11w);
				t_spt_12w=q_add(q_add(q_add(q_add(t_sp1_12w,t_sp2_12w),t_sp3_12w),t_sp4_12w),t_sp5_12w);
            	
            	$('#SP1_6').text(t_sp1_6);
            	$('#SP1_7').text(t_sp1_7);
            	$('#SP1_8').text(t_sp1_8);
            	$('#SP1_9').text(t_sp1_9);
            	$('#SP1_10').text(t_sp1_10);
            	$('#SP1_11').text(t_sp1_11);
            	$('#SP1_12').text(t_sp1_12);
            	$('#SP1_6W').text(t_sp1_6w);
            	$('#SP1_7W').text(t_sp1_7w);
            	$('#SP1_8W').text(t_sp1_8w);
            	$('#SP1_9W').text(t_sp1_9w);
            	$('#SP1_10W').text(t_sp1_10w);
            	$('#SP1_11W').text(t_sp1_11w);
            	$('#SP1_12W').text(t_sp1_12w);
            	//---------------------------------
            	$('#SP2_6').text(t_sp2_6);
            	$('#SP2_7').text(t_sp2_7);
            	$('#SP2_8').text(t_sp2_8);
            	$('#SP2_9').text(t_sp2_9);
            	$('#SP2_10').text(t_sp2_10);
            	$('#SP2_11').text(t_sp2_11);
            	$('#SP2_12').text(t_sp2_12);
            	$('#SP2_6W').text(t_sp2_6w);
            	$('#SP2_7W').text(t_sp2_7w);
            	$('#SP2_8W').text(t_sp2_8w);
            	$('#SP2_9W').text(t_sp2_9w);
            	$('#SP2_10W').text(t_sp2_10w);
            	$('#SP2_11W').text(t_sp2_11w);
            	$('#SP2_12W').text(t_sp2_12w);
            	//---------------------------------
            	$('#SP3_6').text(t_sp3_6);
            	$('#SP3_7').text(t_sp3_7);
            	$('#SP3_8').text(t_sp3_8);
            	$('#SP3_9').text(t_sp3_9);
            	$('#SP3_10').text(t_sp3_10);
            	$('#SP3_11').text(t_sp3_11);
            	$('#SP3_12').text(t_sp3_12);
            	$('#SP3_6W').text(t_sp3_6w);
            	$('#SP3_7W').text(t_sp3_7w);
            	$('#SP3_8W').text(t_sp3_8w);
            	$('#SP3_9W').text(t_sp3_9w);
            	$('#SP3_10W').text(t_sp3_10w);
            	$('#SP3_11W').text(t_sp3_11w);
            	$('#SP3_12W').text(t_sp3_12w);
            	//---------------------------------
            	$('#SP4_6').text(t_sp4_6);
            	$('#SP4_7').text(t_sp4_7);
            	$('#SP4_8').text(t_sp4_8);
            	$('#SP4_9').text(t_sp4_9);
            	$('#SP4_10').text(t_sp4_10);
            	$('#SP4_11').text(t_sp4_11);
            	$('#SP4_12').text(t_sp4_12);
            	$('#SP4_6W').text(t_sp4_6w);
            	$('#SP4_7W').text(t_sp4_7w);
            	$('#SP4_8W').text(t_sp4_8w);
            	$('#SP4_9W').text(t_sp4_9w);
            	$('#SP4_10W').text(t_sp4_10w);
            	$('#SP4_11W').text(t_sp4_11w);
            	$('#SP4_12W').text(t_sp4_12w);
            	//---------------------------------
            	$('#SP5_6').text(t_sp5_6);
            	$('#SP5_7').text(t_sp5_7);
            	$('#SP5_8').text(t_sp5_8);
            	$('#SP5_9').text(t_sp5_9);
            	$('#SP5_10').text(t_sp5_10);
            	$('#SP5_11').text(t_sp5_11);
            	$('#SP5_12').text(t_sp5_12);
            	$('#SP5_6W').text(t_sp5_6w);
            	$('#SP5_7W').text(t_sp5_7w);
            	$('#SP5_8W').text(t_sp5_8w);
            	$('#SP5_9W').text(t_sp5_9w);
            	$('#SP5_10W').text(t_sp5_10w);
            	$('#SP5_11W').text(t_sp5_11w);
            	$('#SP5_12W').text(t_sp5_12w);
            	//---------------------------------
            	$('#SPT_6').text(t_spt_6);
            	$('#SPT_7').text(t_spt_7);
            	$('#SPT_8').text(t_spt_8);
            	$('#SPT_9').text(t_spt_9);
            	$('#SPT_10').text(t_spt_10);
            	$('#SPT_11').text(t_spt_11);
            	$('#SPT_12').text(t_spt_12);
            	$('#SPT_6W').text(t_spt_6w);
            	$('#SPT_7W').text(t_spt_7w);
            	$('#SPT_8W').text(t_spt_8w);
            	$('#SPT_9W').text(t_spt_9w);
            	$('#SPT_10W').text(t_spt_10w);
            	$('#SPT_11W').text(t_spt_11w);
            	$('#SPT_12W').text(t_spt_12w);
			}
			
		</script>
		<style type="text/css">
            #dmain {
                /*overflow: hidden;*/
            }
            .dview {
                float: left;
                border-width: 0px;
                width: 30%;
            }
            .tview {
                border: 5px solid gray;
                font-size: medium;
                background-color: black;
            }
            .tview tr {
                height: 30px;
            }
            .tview td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: #FFFF66;
                color: blue;
            }
            .dbbm {
                float: left;
                width: 70%;
                /*margin: -1px;
                 border: 1px black solid;*/
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
                width: 1%;
            }
            .tbbm tr td span {
                float: right;
                display: block;
                width: 5px;
                height: 10px;
            }
            .tbbm tr td .lbl {
                float: right;
                color: black;
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

            .num {
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
            input[type="text"], input[type="button"] ,select{
                font-size: medium;
            }
            .dbbs {
                width: 1750px;
            }
            .dbbs .tbbs {
                margin: 0;
                padding: 2px;
                border: 2px lightgrey double;
                border-spacing: 1;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                /*background: #cad3ff;*/
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
		<div id='dmain' >
			<div class="dview" id="dview" >
				<table class="tview" id="tview" >
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:20%"><a id='vewNoa'> </a></td>
						<td align="center" style="width:25%"><a id='vewCust'> </a></td>
						<td align="center" style="width:35%"><a id='vewMech'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=' '/></td>
						<td align="center" id='noa'>~noa</td>
						<td align="center" id='cust'>~cust</td>
						<td align="center" id='mech'>~mech</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm" id="tbbm">
					<tr>
						<td><span> </span><a id="lblNoa" class="lbl"> </a></td>
						<td><input id="txtNoa"  type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblDatea" class="lbl"> </a></td>
						<td><input id="txtDatea"  type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblBdate" class="lbl"> </a></td>
						<td><input id="txtBdate"  type="text" class="txt c1"/></td>
						<td> </td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCust" class="lbl btn"> </a></td>
						<td><input id="txtCustno"  type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtCust"  type="text" class="txt c1"/> </td>
						<td><span> </span><a id="lblMech" class="lbl"> </a></td>
						<td colspan="2">
							<input id="txtMech"  type="text" class="txt c1" style="width: 90%;"/>
							<select id="combAccount" class="txt" style="width: 20px;"> </select>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl"> </a></td>
						<td colspan="3"><input id="txtMemo"  type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblProduct" class="lbl"> </a></td>
						<td>
							<input id="txtTypea" type="text" class="txt c1" style="width: 70%;"/>
							<select id="combProduct" class="txt" style="width: 20px;"> </select>
						</td>
						<td align="center"><input id="btnShowpara" type="button" value="參數顯示"></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblWorker" class="lbl"> </a></td>
						<td><input id="txtWorker" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblWorker2" class="lbl"> </a></td>
						<td><input id="txtWorker2" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblWeight1" class="lbl">直料重量</a></td>
						<td><input id="textWeight1" type="text" class="txt num c1"/></td>
						<td><span> </span><a id="lblWeight3" class="lbl">車牙重量</a></td>
						<td><input id="textWeight3" type="text" class="txt num c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblGen" class="lbl"> </a></td>
						<td>
							<input id="checkGen" type="checkbox"/>
							<input id="txtGen" type="hidden"/>
						</td>
						<td><span> </span><a id="lblWeight" class="lbl"> </a></td>
						<td><input id="textWeight" type="text" class="txt num c1"/></td>
						<td><span> </span><a id="lblWeight2" class="lbl">彎料重量</a></td>
						<td><input id="textWeight2" type="text" class="txt num c1"/></td>
						<td><span> </span><a id="lblWeight4" class="lbl btn">車牙頭數</a></td>
						<td><input id="textWeight4" type="text" class="txt num c1"/></td>
					</tr>
				</table>
			</div>
			<div>
				<table style="color: White;width: 825px;font-weight: bold;text-align: center;border: 2px white double;padding: 2px;">
					<tr style="background: forestgreen;">
						<td style="width: 75px;">號數</td>
						<td style="width: 75px;">#3</td>
						<td style="width: 75px;">#4</td>
						<td style="width: 75px;">#5</td>
						<td style="width: 75px;">#6</td>
						<td style="width: 75px;">#7</td>
						<td style="width: 75px;">#8</td>
						<td style="width: 75px;">#9</td>
						<td style="width: 75px;">#10</td>
						<td style="width: 75px;">#11</td>
						<td style="width: 75px;">#12</td>
					</tr>
					<tr style="background: darkseagreen;">
						<td style="background: forestgreen;">SD280</td>
						<td id='S2_3'> </td><td id='S2_4'> </td><td id='S2_5'> </td><td id='S2_6'> </td><td id='S2_7'> </td><td id='S2_8'> </td><td id='S2_9'> </td><td id='S2_10'> </td><td id='S2_11'> </td><td id='S2_12'> </td>
					</tr>
					<tr style="background: mediumaquamarine;">
						<td style="background: forestgreen;">SD280W</td>
						<td id='S2W_3'> </td><td id='S2W_4'> </td><td id='S2W_5'> </td><td id='S2W_6'> </td><td id='S2W_7'> </td><td id='S2W_8'> </td><td id='S2W_9'> </td><td id='S2W_10'> </td><td id='S2W_11'> </td><td id='S2W_12'> </td>
					</tr>
					<tr style="background: darkseagreen;">
						<td style="background: forestgreen;">SD420W</td>
						<td id='S4W_3'> </td><td id='S4W_4'> </td><td id='S4W_5'> </td><td id='S4W_6'> </td><td id='S4W_7'> </td><td id='S4W_8'> </td><td id='S4W_9'> </td><td id='S4W_10'> </td><td id='S4W_11'> </td><td id='S4W_12'> </td>
					</tr>
				</table>
			</div>
			<div class='dbbs' >
				<table id="tbbs" class='tbbs'  border="1"  cellpadding='2' cellspacing='1'  >
					<tr style='color:White; background:#003366;'>
						<td align="center" style="width: 1%;"><input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  /></td>
						<td align="center" style="width: 150px;"><a id='lblOrdeno_s'> </a><input class="btn"  id="btnOrdeCopy" type="button" value='≡' style="font-weight: bold;"  /></td>
						<td style="width:150px;display: none;"><a id='lblProduct_s'> </a><input class="btn"  id="btnProductCopy" type="button" value='≡' style="font-weight: bold;"  /></td>
						<td style="width:150px;"><a id='lblUcolor_s'> </a><input class="btn"  id="btnUcolorCopy" type="button" value='≡' style="font-weight: bold;"  /></td>
						<td style="width:150px;"><a id='lblSpec_s'> </a><input class="btn"  id="btnSpecCopy" type="button" value='≡' style="font-weight: bold;"  /></td>
						<td style="width:85px;"><a id='lblSize_s'> </a><input class="btn"  id="btnSizeCopy" type="button" value='≡' style="font-weight: bold;"  /></td>
						<td style="width:85px;"><a id='lblLengthb_s'> </a></td>
						<!--<td style="width:55px;"><a id='lblUnit_s'> </a></td>-->
						<td style="width:85px;"><a id='lblMount1_s'> </a></td>
						<td style="width:85px;"><a id='lblMount_s'> </a></td>
						<td style="width:85px;"><a id='lblWeight_s'> </a></td>
						<td style="width:120px;"><a id='lblClass_s'> </a><input class="btn"  id="btnClassCopy" type="button" value='≡' style="font-weight: bold;"  /></td>
						<td style="width:90px;">
							<a id='lblBtime_s'> </a>
							<input class="btn" id="btnBtimeCopy" type="button" value='≡' style="font-weight: bold;"  />
						</td>
						<td style="width:90px;">
							<a id='lblEtime_s'> </a>
							<input class="btn" id="btnEtimeCopy" type="button" value='≡' style="font-weight: bold;"  />
						</td>
						<td style="width:150px;"><a id='lblMemo_s'> </a><input class="btn"  id="btnMemoCopy" type="button" value='≡' style="font-weight: bold;"  /></td>
						<td style="width:40px;"><a id='lblRadius_s'> </a></td>
						<td style="width:40px;"><a id='lblMount2_s'> </a></td>
						<td class="img" style="width:120px;"><a id='lblStyle_s'> </a></td>
						<td class="img" style="width:200px;"><a id='lblPic_s'> </a></td>
						<td style="width:100px;display: none;" class="para"><a id='lblParaa_s'> </a></td>
						<td style="width:100px;display: none;" class="para"><a id='lblParab_s'> </a></td>
						<td style="width:100px;display: none;" class="para"><a id='lblParac_s'> </a></td>
						<td style="width:100px;display: none;" class="para"><a id='lblParad_s'> </a></td>
						<td style="width:100px;display: none;" class="para"><a id='lblParae_s'> </a></td>
						<td style="width:150px;display: none;" class="para"><a id='lblScolor_vu_s'>續接名稱</a></td>
						<td style="width:110px;display: none;" class="para"><a id='lblParaf_s'> </a></td>
						<td style="width:110px;display: none;" class="para"><a id='lblParag_s'> </a></td>
						<td style="width:150px;"><a id='lblSize2_s'> </a><input class="btn"  id="btnSize2Copy" type="button" value='≡' style="font-weight: bold;"  /></td>
						<td style="width:40px;"><a id='lblMins_s'> </a></td>
						<td style="width:40px;"><a id='lblWaste_s'> </a></td>
						<td style="width:40px;"><a id='lblHours_s'> </a></td>
					</tr>
					<tr  style='background:#cad3ff;'>
						<td align="center"><input class="btn" id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" /></td>
						<td>
							<input id="txtOrdeno.*" type="text" class="txt c1" />
							<input id="txtNo2.*" type="text" class="txt c1" />
							<input id="txtNoq.*" type="hidden"/>
						</td>
						<td style="display: none;">
							<input id="txtProduct.*" type="text" class="txt c1" style="width: 70%;"/>
							<select id="combProduct.*" class="txt comb" style="width: 20px;"> </select>
						</td>
						<td>
							<input id="txtUcolor.*" type="text" class="txt c1" style="width: 110px;"/>
							<select id="combUcolor.*" class="txt comb" style="width: 20px;"> </select>
						</td>
						<td>
							<input id="txtSpec.*" type="text" class="txt c1" style="width: 70%;"/>
							<select id="combSpec.*" class="txt comb" style="width: 20px;"> </select>
						</td>
						<td><input id="txtSize.*" type="text" class="txt c1" /></td>
						<td><input id="txtLengthb.*" type="text" class="txt num c1" /></td>
						<!--<td><input id="txtUnit.*" type="text" class="txt c1"/></td>-->
						<td><input id="txtMount1.*" type="text" class="txt num c1"/></td>
						<td><input id="txtMount.*" type="text" class="txt num c1"/></td>
						<td><input id="txtWeight.*" type="text" class="txt num c1"/></td>
						<td>
							<input id="txtClass.*" type="text" class="txt c1" style="width: 70%;"/>
							<select id="combClass.*" class="txt comb" style="width: 20px;"> </select>
						</td>
						<td><select id="cmbBtime.*" class="txt c1"> </select></td>
						<td><select id="cmbEtime.*" class="txt c1"> </select></td>
						<td><input id="txtMemo.*" type="text" class="txt c1"/></td>
						<td>
							<input id="checkRadius.*" type="checkbox"/>
							<input id="txtRadius.*" type="hidden"/>
						</td>
						<td><select id="cmbMount2.*" class="txt c1"> </select></td>
						<td class="img">
							<input class="txt" id="txtPicno.*" type="text" style="width:70%;"/>
							<input id="btnPicno.*" type="button" value="." style="width: 1%">
							<input class="txt" id="txtPicname.*" type="text" style="width:95%;"/>
							<input class="txt" id="txtPara.*" type="text" style="display:none;"/>
						</td>
						<td class="img">
							<canvas id="canvas.*" width="150" height="50"> </canvas>
							<img id="imgPic.*" src="" style="display:none;"/>
							<textarea id="txtImgorg.*" style="display:none;"> </textarea>
							<textarea id="txtImgdata.*" style="display:none;"> </textarea>
							<textarea id="txtImgbarcode.*" style="display:none;"> </textarea>
						</td>
						<td class="para" style="display: none;"><input id="txtParaa.*" type="text" class="txt num c1" /></td>
						<td class="para" style="display: none;"><input id="txtParab.*" type="text" class="txt num c1" /></td>
						<td class="para" style="display: none;"><input id="txtParac.*" type="text" class="txt num c1" /></td>
						<td class="para" style="display: none;"><input id="txtParad.*" type="text" class="txt num c1" /></td>
						<td class="para" style="display: none;"><input id="txtParae.*" type="text" class="txt num c1" /></td>
						<td class="para" style="display: none;"><select id="cmbScolor.*" class="txt c1"> </select></td>
						<td class="para" style="display: none;">
							<input id="txtParaf.*" type="text" class="txt c1"/>
							<select id="combParaf1.*" class="txt comb"> </select>
							<select id="combParaf2.*" class="txt comb"> </select>
							<!--<select id="combParaf.*" class="txt" style="width: 20px;"> </select>-->
						</td>
						<td class="para" style="display: none;">
							<input id="txtParag.*" type="text" class="txt c1"/>
							<select id="combParag1.*" class="txt comb"> </select>
							<select id="combParag2.*" class="txt comb"> </select>
							<!--<select id="combParag.*" class="txt" style="width: 20px;"> </select>-->
						</td>
						<td><input id="txtSize2.*" type="text" class="txt c1"/></td>
						<td>
							<input id="checkMins.*" type="checkbox"/>
							<input id="txtMins.*" type="hidden"/>
						</td>
						<td>
							<input id="checkWaste.*" type="checkbox"/>
							<input id="txtWaste.*" type="hidden"/>
						</td>
						<td>
							<input id="checkHours.*" type="checkbox"/>
							<input id="txtHours.*" type="hidden"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<input id="q_sys" type="hidden" />
		<div id="splicertotal" style="display: none;">
			<table style="color: White;width: 910px;font-weight: bold;text-align: center;border: 2px white double;padding: 2px;">
				<tr style="background: forestgreen;">
					<td style="width: 105px;">牙頭規格</td>
					<td style="width: 115px;" colspan="2">#6</td>
					<td style="width: 115px;" colspan="2">#7</td>
					<td style="width: 115px;" colspan="2">#8</td>
					<td style="width: 115px;" colspan="2">#9</td>
					<td style="width: 115px;" colspan="2">#10</td>
					<td style="width: 115px;" colspan="2">#11</td>
					<td style="width: 115px;" colspan="2">#12</td>
				</tr>
				<tr style="background: darkseagreen;">
					<td style="background: forestgreen;">公_直牙</td>
					<td id='SP1_6' style="width: 45px;"> </td><td id='SP1_6W' style="width: 70px;"> </td>
					<td id='SP1_7' style="width: 45px;"> </td><td id='SP1_7W' style="width: 70px;"> </td>
					<td id='SP1_8' style="width: 45px;"> </td><td id='SP1_8W' style="width: 70px;"> </td>
					<td id='SP1_9' style="width: 45px;"> </td><td id='SP1_9W' style="width: 70px;"> </td>
					<td id='SP1_10' style="width: 45px;"> </td><td id='SP1_10W' style="width: 70px;"> </td>
					<td id='SP1_11' style="width: 45px;"> </td><td id='SP1_11W' style="width: 70px;"> </td>
					<td id='SP1_12' style="width: 45px;"> </td><td id='SP1_12W' style="width: 70px;"> </td>
				</tr>
				<tr style="background: mediumaquamarine;">
					<td style="background: forestgreen;">母_直牙</td>
					<td id='SP2_6'> </td><td id='SP2_6W'> </td>
					<td id='SP2_7'> </td><td id='SP2_7W'> </td>
					<td id='SP2_8'> </td><td id='SP2_8W'> </td>
					<td id='SP2_9'> </td><td id='SP2_9W'> </td>
					<td id='SP2_10'> </td><td id='SP2_10W'> </td>
					<td id='SP2_11'> </td><td id='SP2_11W'> </td>
					<td id='SP2_12'> </td><td id='SP2_12W'> </td>
				</tr>
				<tr style="background: darkseagreen;">
					<td style="background: forestgreen;">公_錐牙</td>
					<td id='SP3_6'> </td><td id='SP3_6W'> </td>
					<td id='SP3_7'> </td><td id='SP3_7W'> </td>
					<td id='SP3_8'> </td><td id='SP3_8W'> </td>
					<td id='SP3_9'> </td><td id='SP3_9W'> </td>
					<td id='SP3_10'> </td><td id='SP3_10W'> </td>
					<td id='SP3_11'> </td><td id='SP3_11W'> </td>
					<td id='SP3_12'> </td><td id='SP3_12W'> </td>
				</tr>
				<tr style="background: mediumaquamarine;">
					<td style="background: forestgreen;">母_錐牙</td>
					<td id='SP4_6'> </td><td id='SP4_6W'> </td>
					<td id='SP4_7'> </td><td id='SP4_7W'> </td>
					<td id='SP4_8'> </td><td id='SP4_8W'> </td>
					<td id='SP4_9'> </td><td id='SP4_9W'> </td>
					<td id='SP4_10'> </td><td id='SP4_10W'> </td>
					<td id='SP4_11'> </td><td id='SP4_11W'> </td>
					<td id='SP4_12'> </td><td id='SP4_12W'> </td>
				</tr>
				<tr style="background: darkseagreen;">
					<td style="background: forestgreen;">T頭</td>
					<td id='SP5_6'> </td><td id='SP5_6W'> </td>
					<td id='SP5_7'> </td><td id='SP5_7W'> </td>
					<td id='SP5_8'> </td><td id='SP5_8W'> </td>
					<td id='SP5_9'> </td><td id='SP5_9W'> </td>
					<td id='SP5_10'> </td><td id='SP5_10W'> </td>
					<td id='SP5_11'> </td><td id='SP5_11W'> </td>
					<td id='SP5_12'> </td><td id='SP5_12W'> </td>
				</tr>
				<tr style="background: cornflowerblue;">
					<td style="background: blue;">合計</td>
					<td id='SPT_6'> </td><td id='SPT_6W'> </td>
					<td id='SPT_7'> </td><td id='SPT_7W'> </td>
					<td id='SPT_8'> </td><td id='SPT_8W'> </td>
					<td id='SPT_9'> </td><td id='SPT_9W'> </td>
					<td id='SPT_10'> </td><td id='SPT_10W'> </td>
					<td id='SPT_11'> </td><td id='SPT_11W'> </td>
					<td id='SPT_12'> </td><td id='SPT_12W'> </td>
				</tr>
			</table>
		</div>
		<div id='dbbssplicer' style="display: none;">
			<table id="tbbssplicer" class='tbbs'  border="1"  cellpadding='2' cellspacing='1'>
				<tr style='color:White; background:#003366;text-align: center;'>
					<td style="width:100px;display: none;"><a id='lblNoq_ss'> </a></td>
					<td style="width:150px;"><a id='lblOrdeno_ss'>訂單編號/訂序</a></td>
					<td style="width:150px;"><a id='lblSpec_ss'>材質</a></td>
					<td style="width:85px;"><a id='lblSize_ss'>號數</a></td>
					<td style="width:85px;"><a id='lblLengthb_ss'>長度</a></td>
					<td style="width:85px;"><a id='lblMount1_ss'>支數</a></td>
					<td style="width:85px;"><a id='lblWeight_ss'>重量</a></td>
					<td style="width:40px;"><a id='lblMount2_ss'>端頭</a></td>
					<td style="width:160px;"><a id='lblScolor_ss'>產品名稱</a></td>
					<td style="width:300px;"><a id='lblParafg_ss'>車頭規格套件</a></td>
					<td style="width:40px;"><a id='lblRadius_ss'>彎</a></td>
					<td style="width:150px;"><a id='lblPic_ss'>形狀</a></td>
					<td style="width:150px;"><a id='lblMemo_ss'>備註(標籤)</a></td>
				</tr>
			</table>
		</div>
	</body>
</html>
