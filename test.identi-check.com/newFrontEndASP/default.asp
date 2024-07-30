
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--#include file="headNew.asp" -->
            <link href="css/homeSlider.css" rel="stylesheet" type="text/css" />
            <script src="//ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.min.js"></script>
            <script type="text/javascript" src="scripts/jquery.jshowoff.min.js"></script>

<!-- *************************************** MAIN CONTENT AREA *************************************** -->
<div id="homeSlideHold">
            <div id="slidingFeatures">
				<div title='EMPLOYMENT SCREENING'>
                <a href="employmentScreening.asp"><img src="img/homeS/screening.jpg" /></a>
                </div><!--end emplyment screening-->
				<div title="UCC SEARCHES & FILING">
                <a href="uccSearches.asp"><img src="img/homeS/uccImg.jpg" /></a>
                </div><!--end ucc Searches and filing-->
				<div title="TENANT SCREENING">
                <a href="tenantScreening.asp"><img src="img/homeS/tenantScreening.jpg" /></a>
                </div><!--end tenant screening-->
				<div title="DRUG TESTING">
                <a href="drugTesting.asp"><img src="img/homeS/drugTesting.jpg" /></a>
                </div><!--end drug testing-->
			    <div title="CREDIT RECORDS">
                <a href="https://www.creditcommander.com/identicheck/"><img src="img/homeS/creditRecords.jpg" /></a>
                </div><!--end credit records-->
            </div>
            <div style="clear:both"></div>
</div>
			<script type="text/javascript">
			    $(document).ready(function () {
			        $('#slidingFeatures').jshowoff({
			            effect: 'slideLeft',
			            controls: false,
			            hoverPause: false
			        });
			    });
			</script>
<!-- ************************************* END MAIN CONTENT AREA ************************************* -->

    
<!--#include file="footNew.asp" -->

</body>
</html>
