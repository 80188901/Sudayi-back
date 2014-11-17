	$(document).ready(function(){
			document.addEventListener("deviceready", myDeviceReadyListener, false);
	});
	
	function myDeviceReadyListener(){
		$("#content").on('click','.pic',function(){
		var a=$(this)
 			navigator.camera.getPicture(function(imageURI){
 				$width=a.parent().width();
 				$height=a.parent().height();
 				$img="<img src='"+imageURI+"' width='"+$width+"' height='"+$height+"'/>";
 				a.parent().append($img);
			    a.hide();	
 			}, onFail, { 
 				quality: 70,
			    destinationType: Camera.DestinationType.FILE_URL, //以文件地址返回url
			    //sourceType:Camera.PictureSourceType.Camera,
			    sourceType:Camera.PictureSourceType.PHOTOLIBRARY,
			   // mediaType:Camera.MediaType.VIDEO,
			}); 			
 		})
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
			
			$(this).parent().children().show();
			$(this).remove();
			$id=$(this).attr("class");
 			$("#"+$id).val("");
				return true;
				}
				return false;


 		
 	 })
    
})	