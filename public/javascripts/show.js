$(function(){

		$("#every").change(function(){
			$val=$('#every option:selected').text();
			if($val=='每日'){
				$('.every_week').hide();
				$('.every_day').show();
			}else if($val=='每周'){
				$('.every_day').hide();
				$('.every_week').show();
			}else{
				$('.every_week ,.every_day').hide();
			}
		})
	})