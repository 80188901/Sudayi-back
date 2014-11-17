	$(document).ready(function(){
			document.addEventListener("deviceready", myDeviceReadyListener, false);
	});
	
	function myDeviceReadyListener(){
		$('#adv').click(function(){
 			navigator.camera.getPicture(onSuccess1, onFail, { 
 				quality: 70,
			    destinationType: Camera.DestinationType.FILE_URL, //以文件地址返回url
			    //sourceType:Camera.PictureSourceType.Camera,
			    sourceType:Camera.PictureSourceType.PHOTOLIBRARY,
			   // mediaType:Camera.MediaType.VIDEO,
			}); 			
 		})
 		$('#cover').click(function(){
 			navigator.camera.getPicture(onSuccess2, onFail, { 
 				quality: 70,
			    destinationType: Camera.DestinationType.FILE_URL, //以文件地址返回url
			    sourceType:Camera.PictureSourceType.Camera,
			    sourceType:Camera.PictureSourceType.PHOTOLIBRARY,
			   // mediaType:Camera.MediaType.VIDEO,
			}); 			
 		})
 		
 		$("#detail").click(function(){
	 		navigator.camera.getPicture(onSuccess3, onFail, { 
	 				quality: 70,
				    destinationType: Camera.DestinationType.FILE_URL, //以文件地址返回url
				    sourceType:Camera.PictureSourceType.Camera,
				    sourceType:Camera.PictureSourceType.PHOTOLIBRARY,
				   // mediaType:Camera.MediaType.VIDEO,
				}); 	
 		})
	}
	function onSuccess1(imageURI){
		$condition=$("#advs").val();
		if($condition==""){
		$width=$("#content").width();
		$img="<img src='"+imageURI+"' width='"+$width+"' height='100' class='advs'/>";
		$(".adv").append($img);
		$("#advs").val(imageURI);
		}else{
			alert("只允许上传一张图片");
		}
		
	}
	
	function onSuccess2(imageURI){
		$condition=$("#covers").val();
		if($condition==""){
		$width=$("#content").width();
		$img="<img src='"+imageURI+"' width='"+$width+"' height='100' class='covers'/>";
		$(".cover").append($img);
		$("#covers").val(imageURI);
		}else{
			alert("只允许上传一张图片");
		}	
	}
	
	function onSuccess3(imageURI){
		$width=$("#content").width();
		$img="<img src='"+imageURI+"' width='"+$width+"' height='100' class='details'/>";
		$(".detail").append($img);
		$detail=$("#details").val();
		$detail=$detail+','+imageURI;
		$de=$("#details").val($detail);
		
	}
	function onFail(message) {
	    alert('请重新选择');
	}
	
	
$(function(){
	$("#submit").click(function(){
		$("img").each(function(){
		   var imageURI = $(this).attr("src");
		   var options = new FileUploadOptions();
           options.fileKey="file";
           options.fileName=imageURI.substr(imageURI.lastIndexOf('/')+1);
           options.fileName+='.jpg';
           options.mimeType="image/jpeg";
           var params = {};
           params.name = "iden";
           options.params = params;
          var ft = new FileTransfer();
           ft.upload(imageURI, encodeURI("http://yongxinghua.is-great.net/upload.php"), win, fail, options);
		})       
	})
	 function win(r) {
			alert("上传成功");
       }

        function fail(error) {
            alert("An error has occurred: Code = " + error.code);
            console.log("upload error source " + error.source);
            console.log("upload error target " + error.target);
        }
        
        
     $("#content").on("taphold","img",function(){
  	
			if(confirm("确定删除")){
			$(this).remove();
			$id=$(this).attr("class");
 			$("#"+$id).val("");
				return true;
				}
				return false;


 		
 	 })
    
})	