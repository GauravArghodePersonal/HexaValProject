		function resizeIframe() {
			var minHeight = 0;
	        var maxHeight = 9999;
	        var extraHeight = 14;
	        
	        var thisWindow = window.name;
	        if(thisWindow) {        
	        	var iframes = parent.document.getElementsByName(thisWindow);
	            if (iframes) {            
	            	var height = document.body.scrollHeight;

	                height += extraHeight;

	                if (height < minHeight) {height = minHeight;}
	                if (height > maxHeight) {height = maxHeight;} 

	                iframes[0].style.height = height + "px";
	                iframes[0].scrolling="auto";
	            }   
	        }
	    }
	    
function resizeIframe_windowName(windowName) {
			var minHeight = 0;
	        var maxHeight = 9999;
	        var extraHeight = 14;
	        
	        var thisWindow = windowName;
	        if(thisWindow) {        
	        	var iframes = parent.document.getElementsByName(thisWindow);
	            if (iframes) {            
	            	var height = document.body.scrollHeight;

	                height += extraHeight;

	                if (height < minHeight) {height = minHeight;}
	                if (height > maxHeight) {height = maxHeight;} 

	                iframes[0].style.height = height + "px";
	                iframes[0].scrolling="auto";
	            }   
	        }
	    }	    