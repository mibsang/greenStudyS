<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Main Home</title>
<jsp:include page="/WEB-INF/views/include/w3.jsp" />
<link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/images/greenStudySLogo.svg">
<script src="${ctp}/js/pointerSpectrum.js" ></script>
<style>
body {font-family: "Lato", sans-serif}
.mySlides {display: none}
</style>
</head>
<body class="d-flex flex-column min-vh-100">
<!-- Navbar -->
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<!-- Page content -->
<div class="w3-content" style="max-width:2000px;margin-top:46px">

  <!-- Automatic Slideshow Images -->
	<jsp:include page="/WEB-INF/views/include/slide.jsp" />
  
  <!-- The Band Section -->
  <div class="w3-container w3-content w3-center w3-padding-64" style="max-width:800px" id="band">
    <h2 class="w3-wide">THE SEASONS</h2>
    <p class="w3-opacity"><i>We love music</i></p>
    <p class="w3-justify">
    	Every season has its own melody, a beautiful rhythm that makes each moment feel special.
			Spring arrives with gentle tunes and fresh beginnings, while summer fills our days with bright and joyful sounds.
			Autumn brings warm melodies that remind us of precious memories and moments we wish could last forever.
			Winter wraps the world in peaceful harmonies, bringing comfort and a little magic to the coldest days.
			Through every changing season, music stays by our side, turning ordinary days into unforgettable stories.
			Discover the songs that capture the beauty of each season, and let their melodies become the soundtrack of your life.
		</p>
    <div class="w3-row w3-padding-32">
      <div class="w3-quarter">
        <p>Spring</p>
        <img src="${ctp}/images/HereComesTheSun.jpg" class="w3-round w3-margin-bottom" alt="Here Comes The Sun" style="width:60%">
        <div>The Beatles</div>
        <div style="font-size: 13px;">- Here Comes The Sun</div>
      </div>
      <div class="w3-quarter">
        <p>Summer</p>
        <img src="${ctp}/images/WatermelonSugar.jpg" class="w3-round w3-margin-bottom" alt="Watermelon Sugar" style="width:60%">
      	<div>Harry Styles</div>
      	<div style="font-size: 13px;">- Watermelon Sugar</div>
      </div>
      <div class="w3-quarter">
        <p>Autumn</p>
        <img src="${ctp}/images/WakeMeUpWhenSeptemberEnds.jpg" class="w3-round w3-margin-bottom" alt="Wake Me Up When" style="width:60%">
      	<div>GreenDay</div>
      	<div style="font-size: 13px;">- Wake Me Up When<br> September Ends</div>
      </div>
      <div class="w3-quarter">
        <p>Winter</p>
        <img src="${ctp}/images/Snowman.jpg" class="w3-round w3-margin-bottom" alt="Snowman" style="width:60%">
      	<div>Sia</div>
      	<div style="font-size: 13px;">- Snowman</div>
      </div>
    </div>
  </div>

  <!-- The Tour Section -->
  <div class="w3-red" id="tour">
    <div class="w3-container w3-content w3-padding-64" style="max-width:800px">
      <h2 class="w3-wide w3-center">CONCERT</h2>
      <p class="w3-opacity w3-center"><i>Remember to book your tickets!</i></p><br>

      <ul class="w3-ul w3-border w3-white w3-text-grey">
        <li class="w3-padding">October <span class="w3-tag w3-red w3-margin-left">Sold out</span></li>
        <li class="w3-padding">November <span class="w3-tag w3-red w3-margin-left">Sold out</span></li>
        <li class="w3-padding">December <span class="w3-badge w3-right w3-margin-right">3</span></li>
      </ul>

      <div class="w3-row-padding w3-padding-32" style="margin:0 -16px">
        <div class="w3-third w3-margin-bottom">
          <img src="${ctp}/images/LeeSeungChul.jpg" alt="New York" style="width:100%" class="w3-hover-opacity">
          <div class="w3-container w3-white">
            <p><b>Lee SeungChul</b></p>
            <p class="w3-opacity">Sat 12 Dec 2026</p>
            <p style="min-height:48px;">THE VOICE: LEE SEUNG CHUL</p>
            <button class="w3-button w3-black w3-margin-bottom" onclick="document.getElementById('ticketModal').style.display='block'">Buy Tickets</button>
          </div>
        </div>
        <div class="w3-third w3-margin-bottom">
          <img src="${ctp}/images/DynamicDuo.jpg" alt="Paris" style="width:100%" class="w3-hover-opacity">
          <div class="w3-container w3-white w3-border">
            <p><b>Dynamic Duo</b></p>
            <p class="w3-opacity">Sat 19 Dec 2026</p>
            <p style="min-height:48px;">“가끔씩 오래 보자”</p>
            <button class="w3-button w3-black w3-margin-bottom" onclick="document.getElementById('ticketModal').style.display='block'">Buy Tickets</button>
          </div>
        </div>
        <div class="w3-third w3-margin-bottom">
          <img src="${ctp}/images/KimNaYeong.jpg" alt="San Francisco" style="width:100%" class="w3-hover-opacity">
          <div class="w3-container w3-white">
            <p><b>Kim NaYeong</b></p>
            <p class="w3-opacity">Fri 25 Dec 2026</p>
            <p style="min-height:48px;">“Na” On The Voice : 우리 - 마침내 이곳에</p>
            <button class="w3-button w3-black w3-margin-bottom" onclick="document.getElementById('ticketModal').style.display='block'">Buy Tickets</button>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Ticket Modal -->
  <div id="ticketModal" class="w3-modal">
    <div class="w3-modal-content w3-animate-top w3-card-4">
      <header class="w3-container w3-teal w3-center w3-padding-32"> 
        <span onclick="document.getElementById('ticketModal').style.display='none'" 
       class="w3-button w3-teal w3-xlarge w3-display-topright">×</span>
        <h2 class="w3-wide"><i class="fa fa-suitcase w3-margin-right"></i>Tickets</h2>
      </header>
      <div class="w3-container">
        <p><label><i class="fa fa-shopping-cart"></i> Tickets, $15 per person</label></p>
        <input class="w3-input w3-border" type="text" placeholder="How many?">
        <p><label><i class="fa fa-user"></i> Send To</label></p>
        <input class="w3-input w3-border" type="text" placeholder="Enter email">
        <button class="w3-button w3-block w3-teal w3-padding-16 w3-section w3-right">PAY <i class="fa fa-check"></i></button>
        <button class="w3-button w3-red w3-section" onclick="document.getElementById('ticketModal').style.display='none'">Close <i class="fa fa-remove"></i></button>
        <p class="w3-right">Need <a href="#" class="w3-text-blue">help?</a></p>
      </div>
    </div>
  </div>

  <!-- The Contact Section -->
  <div class="w3-container w3-content w3-padding-32" style="max-width:800px" id="contact">
    <h2 class="w3-wide w3-center">CONTACT</h2>
    <p class="w3-opacity w3-center"><i>Need a help? Drop a note!</i></p>
    <div class="w3-row w3-padding-32">
      <div class="w3-col m6 w3-large w3-margin-bottom">
        <i class="fa fa-map-marker" style="width:30px"></i> CheongJu, KOR<br>
        <i class="fa fa-phone" style="width:30px"></i> Phone : +82) 010 4444 4444<br>
        <i class="fa fa-envelope" style="width:30px"></i> Email : admin1234@gmail.com<br>
      </div>
      <div class="w3-col m6">
        <form action="/action_page.php" target="_blank">
          <div class="w3-row-padding" style="margin:0 -16px 8px -16px">
            <div class="w3-half">
              <input class="w3-input w3-border" type="text" placeholder="Name" required name="Name">
            </div>
            <div class="w3-half">
              <input class="w3-input w3-border" type="text" placeholder="Email" required name="Email">
            </div>
          </div>
          <input class="w3-input w3-border" type="text" placeholder="Message" required name="Message">
          <button class="w3-button w3-black w3-section w3-right" type="submit">SEND</button>
        </form>
      </div>
    </div>
  </div>
  
<!-- End Page Content -->
</div>

<!-- Image of location/map -->
<img src="${ctp}/images/map.png" class="w3-image w3-greyscale-min" style="width:100%">

<!-- Footer -->
<jsp:include page="/WEB-INF/views/include/footer.jsp" />


</body>
</html>
