<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<style>
  .slide-caption {
	  background: radial-gradient(ellipse at center, rgba(255, 255, 255, 0.7) 40%, rgba(255, 255, 255, 0) 72%);
	  padding: 16px 64px !important;   
	  margin-bottom: 16px;
	  width: max-content;
	  max-width: 90%;
	}
  .slide-caption h3 { 
  	margin: 4px 0; 
  }
  .slide-caption p  { 
  	margin: 4px 0 8px; 
  }
  .slide-caption h3, .slide-caption p { 
  	text-shadow: 0 0 6px rgba(255, 255, 255, 0.9); 
  }
</style>
<div class="mySlides w3-display-container w3-center">
  <img src="${ctp}/images/spring.jpg" style="width:100%; height:450px;">
  <div class="w3-display-bottommiddle w3-container w3-text-dark slide-caption w3-padding-32 w3-hide-small">
    <h2>Spring</h2>
    <p><b>And then my heart with pleasure fills, And dances with the daffodils</b></p>   
  </div>
</div>
<div class="mySlides w3-display-container w3-center">
  <img src="${ctp}/images/summer.jpg" style="width:100%; height:450px;">
  <div class="w3-display-bottommiddle w3-container w3-text-dark slide-caption w3-padding-32 w3-hide-small">
    <h2>Summer</h2>
    <p><b>Where summer skies meet the sea, my heart feels free</b></p>    
  </div>
</div>
<div class="mySlides w3-display-container w3-center">
  <img src="${ctp}/images/fall.jpg" style="width:100%; height:450px;">
  <div class="w3-display-bottommiddle w3-container w3-text-dark slide-caption w3-padding-32 w3-hide-small">
    <h2>Autumn</h2>
    <p><b>Every leaf speaks bliss to me, Fluttering from the autumn tree</b></p>    
  </div>
</div>
<div class="mySlides w3-display-container w3-center">
  <img src="${ctp}/images/winter.jpg" style="width:100%; height:450px;">
  <div class="w3-display-bottommiddle w3-container w3-text-dark slide-caption w3-padding-32 w3-hide-small">
    <h2>Winter</h2>
    <p><b>Winter paints the city white, and every street begins to shine</b></p>    
  </div>
</div>

<script>
	// Automatic Slideshow - change image every 4 seconds
	var myIndex = 0;
	carousel();
	
	function carousel() {
	  var i;
	  var x = document.getElementsByClassName("mySlides");
	  for (i = 0; i < x.length; i++) {
	    x[i].style.display = "none";  
	  }
	  myIndex++;
	  if (myIndex > x.length) {myIndex = 1}    
	  x[myIndex-1].style.display = "block";  
	  setTimeout(carousel, 4000);    
	}
	
	// Used to toggle the menu on small screens when clicking on the menu button
	function myFunction() {
	  var x = document.getElementById("navDemo");
	  if (x.className.indexOf("w3-show") == -1) {
	    x.className += " w3-show";
	  } else { 
	    x.className = x.className.replace(" w3-show", "");
	  }
	}
	
	// When the user clicks anywhere outside of the modal, close it
	var modal = document.getElementById('ticketModal');
	window.onclick = function(event) {
	  if (event.target == modal) {
	    modal.style.display = "none";
	  }
	}
</script>