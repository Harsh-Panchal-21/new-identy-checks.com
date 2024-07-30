<%@ Page Title="" Language="VB" MasterPageFile="/newFrontEnd.Net/MasterPage.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
            <title>
            ::: Identi-Check ::: Background Check, Credit History, Statewide Criminal 
			History, Federal Criminal History, County Criminal History, Sex Offender Check, 
			Employment Verification, Education Verification, MVR, Motor Vehicle Report, 
			Civil Search, Workers Compensation Report, Social Security Number Verification 
			and Trace, Military Verification, Professional License Verification, 
			Corporation Search, Drug Testing
            </title>

            <link href="css/homeSlider.css" rel="stylesheet" type="text/css" />
            <script src="//ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.min.js"></script>
            <script type="text/javascript" src="scripts/jquery.jshowoff.min.js"></script>
            

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div id="homeSlideHold">
            <div id="slidingFeatures">
				<div title="IDENTI-CHECK">
                <a href="employmentScreening.asp"><img src="img/homeS/risk.jpg" /></a>
                </div><!--end home first-->
				<div title='EMPLOYMENT SCREENING'>
                <a href="employmentScreening.asp"><img src="img/homeS/screening.jpg" /></a>
                </div><!--end emplyment screening-->
				<div title="UCC SEARCHES & FILING">
                <a href="uccSearches.asp"><img src="img/homeS/uccImg.jpg" /></a>
                </div><!--end ucc Searches and filing-->
				
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
</asp:Content>

