<!DOCTYPE html>
<html>
<head>
    <title>Make an Appointment - Identi-Check, Inc.</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.3.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.1/css/all.css" integrity="sha384-gfdkjb5BdAXd+lj+gudLWI+BXq4IuLW5IT+brZEZsLFm++aCMlF1V92rMkPaX4PP" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
        }
        .form-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .form-container h2 {
            color: #002B6A;
        }
        .form-container label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }
        .form-container input, .form-container select, .form-container textarea {
            width: calc(100% - 22px);
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .form-container button {
            width: 50%;
            padding: 10px;
            background-color: #002B6A;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        .form-container button:hover {
            background-color: #004080;
        }
        .form-container .checkbox-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
        }
        .form-container .checkbox-group label {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            position: relative;
            padding-left: 40px;
            cursor: pointer;
            font-size: 16px;
        }
        .form-container .checkbox-group input[type="checkbox"] {
            position: absolute;
            opacity: 0;
            cursor: pointer;
        }
        .form-container .checkbox-group .checkmark {
            position: absolute;
            top: 0;
            left: 0;
            height: 25px;
            width: 25px;
            background-color: #ccc;
            border-radius: 50%;
        }
        .form-container .checkbox-group input:checked ~ .checkmark {
            background-color: #2196F3;
        }
        .form-container .checkbox-group .checkmark:after {
            content: "";
            position: absolute;
            display: none;
        }
        .form-container .checkbox-group input:checked ~ .checkmark:after {
            display: block;
        }
        .form-container .checkbox-group .checkmark:after {
            left: 9px;
            top: 5px;
            width: 5px;
            height: 10px;
            border: solid white;
            border-width: 0 3px 3px 0;
            transform: rotate(45deg);
        }
        .datetime-container {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        .datepicker-wrapper, .timepicker-wrapper {
            width: 48%;
        }
        .timepicker-wrapper {
            display: flex;
            flex-wrap: wrap;
        }
        .timepicker-wrapper button {
            width: 48%;
            margin: 1%;
        }
        .selected-time-container {
            display: none;
            align-items: center;
            justify-content: space-between;
            background-color: #007bff;
            color: white;
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
        }
        .selected-time-container i {
            margin-right: 10px;
        }
        .selected-time {
            flex-grow: 1;
            text-align: left;
        }
        .cancel-button {
            background-color: white;
            color: #007bff;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }
        .cancel-button:hover {
            background-color: #f0f0f0;
        }
        .header-section {
            background-color: #002b6a; /* Dark Blue Color */
            color: white;
        }
        .header-section .w3-bar-item {
            color: white;
        }
        .header-section .w3-bar-item:hover {
            color: red;
        }
        .timepicker-wrapper .selected {
            background-color: #2196F3;
            color: white;
        }
        .message-box {
            display: none;
            margin-top: 20px;
            padding: 10px;
            background-color: #dff0d8;
            color: #3c763d;
            border: 1px solid #d6e9c6;
            border-radius: 5px;
        }
    </style>
</head>
<body>

<!-- Header -->
<section class="w3-container w3-theme header-section w3-padding">
    <div class="w3-container w3-left">
        <a href="/default.asp">
            <img src="img/weblogo3.png" width="100%" alt="Identi-Check Logo">
        </a>
    </div>
    <div class="w3-container w3-right">
        <a href="/Register.asp" class="w3-bar-item w3-button w3-hover-none">Register</a>
        <a href="/AboutUs.asp" class="w3-bar-item w3-button w3-hover-none">About Us</a>
        <a href="/ContactUs.asp" class="w3-bar-item w3-button w3-hover-none">Contact Us</a>
        <a href="/login.asp" class="w3-bar-item w3-button w3-hover-none">Login</a>
        <a href="/appointment.asp" class="w3-bar-item w3-button w3-hover-none">Make an Appointment</a>
        <div>
            <a href="https://www.facebook.com/identicheckInc/"><img src="img/facebook.png" alt="Facebook"></a>
            <a href="https://www.instagram.com/identcheck/"><img src="img/instagram.png" alt="Instagram"></a>
            <a href="https://www.linkedin.com/company/identi-check-inc-/about/"><img src="img/linkedin.png" alt="LinkedIn"></a>
            <a href="#"><img src="img/twitter.png" alt="Twitter"></a>
            <a href="#"><img src="img/googleplus.png" alt="Google+"></a>
        </div>
    </div>
</section>

<!-- Appointment Form Section -->
<section class="w3-padding-64 w3-light-grey w3-center">
    <div class="form-container">
        <h2 class="w3-text-blue">Appointment Request Form</h2>
        <p>Let us know how we can help you!</p>
<form id="appointmentForm" runat="server">
            <label for="appointment_date_time">What date and time work best for you?</label>
            <div class="datetime-container">
                <div class="datepicker-wrapper">
                    <input type="text" id="appointment_date" name="AppointmentDate" placeholder="Select date" required>
                </div>
                <div class="timepicker-wrapper" id="time-options"></div>
            </div>
            <div id="selected-time-container" class="selected-time-container">
                <i class="fa fa-calendar-check-o"></i>
                <div id="selected-time" class="selected-time"></div>
                <button type="button" id="cancel-selection" class="cancel-button">Cancel Selection</button>
            </div>

            <label for="name">Full Name</label>
            <input type="text" name="FirstName" placeholder="First Name" required>
            <input type="text" name="LastName" placeholder="Last Name" required>

            <label for="contact_number">Contact Number</label>
            <input type="tel" name="ContactNumber" placeholder="(000) 000-0000" required>

            <label for="email">Email Address</label>
            <input type="email" name="Email" placeholder="example@example.com" required>

            <label for="alternative_date_time">Any other specific date and time, if the above selection is not suitable.</label>
            <input type="text" id="alternative_date_time" name="AlternativeDateTime" placeholder="Select date and time">

            <label>What services are you interested in?</label>
            <div class="checkbox-group">
                <label>
                    <input type="checkbox" name="Services" value="Fingerprint">
                    <span class="checkmark"></span>
                    Fingerprinting- Livescan FBI & IL
                </label>
                <label>
                    <input type="checkbox" name="Services" value="BackgroundCheck">
                    <span class="checkmark"></span>
                    Fingerprinting-Livescan IL only
                </label>
                <label>
                    <input type="checkbox" name="Services" value="DrugTesting">
                    <span class="checkmark"></span>
                    Livescan Print Card/Print Card Copy/FBI FD258 Card
                </label>
                <label>
                    <input type="checkbox" name="Services" value="DrugTestUrine">
                    <span class="checkmark"></span>
                    Drug Testing- Urine (Personal/School/Pre-employment)
                </label>
                <label>
                    <input type="checkbox" name="Services" value="DrugTestHair">
                    <span class="checkmark"></span>
                    Drug Testing-Hair
                </label>
            </div>

            <label for="additional_info">Additional Information</label>
            <textarea name="AdditionalInfo" placeholder="Type here..."></textarea>

            <button type="submit">Submit</button>
        </form>
        <div id="messageBox" class="message-box">
            Thank you for your information. We received your response and emailed you a copy.
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="w3-container w3-theme header-section w3-padding-16 w3-center">
    <p>&copy; 2024 Identi-Check, Inc. All rights reserved.</p>
</footer>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>
    flatpickr("#appointment_date", {
        inline: true,
        dateFormat: "Y-m-d",
        minDate: "today",
        onChange: function (selectedDates, dateStr, instance) {
            updateSelectedTime();
        }
    });

    const timeOptions = [
        "8:00 AM", "8:30 AM", "9:00 AM", "9:30 AM",
        "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM", "1:00 PM", "1:30 PM", "2:00 PM", "2:30 PM",
        "3:00 PM", "3:30 PM", "4:00 PM", "4:30 PM"
    ];

    const timeOptionsContainer = document.getElementById("time-options");

    timeOptions.forEach(time => {
        const timeButton = document.createElement("button");
        timeButton.type = "button";
        timeButton.className = "w3-button w3-border w3-margin-small";
        timeButton.textContent = time;
        timeButton.onclick = function () {
            selectTime(time, timeButton);
        };
        timeOptionsContainer.appendChild(timeButton);
    });

    function selectTime(time, button) {
        const selectedDate = document.getElementById("appointment_date").value;
        if (selectedDate) {
            const selectedTimeElement = document.getElementById("selected-time");
            selectedTimeElement.textContent = `Selected Time: ${time} on ${selectedDate}`;
            document.getElementById("selected-time-container").style.display = "flex";

            const timeButtons = document.querySelectorAll('.timepicker-wrapper button');
            timeButtons.forEach(btn => btn.classList.remove('selected'));

            button.classList.add('selected');
        } else {
            alert("Please select a date first.");
        }
    }

    document.getElementById("cancel-selection").onclick = function () {
        document.getElementById("selected-time-container").style.display = "none";
        const timeButtons = document.querySelectorAll('.timepicker-wrapper button');
        timeButtons.forEach(btn => btn.classList.remove('selected'));
    };

    function updateSelectedTime() {
        document.getElementById("selected-time-container").style.display = "none";
        const timeButtons = document.querySelectorAll('.timepicker-wrapper button');
        timeButtons.forEach(btn => btn.classList.remove('selected'));
    }

    document.getElementById("appointmentForm").onsubmit = function (event) {
        event.preventDefault(); // Prevent default form submission

        // Your AJAX call to submit the form data
        const formData = new FormData(document.getElementById("appointmentForm"));

        fetch('AppointmentHandler.aspx', {
            method: 'POST',
            body: formData
        })
            .then(response => response.text())
            .then(data => {
                if (data.trim() === "Success") {
                    document.getElementById("messageBox").style.display = "block";
                } else {
                    alert("Failed to send email. Please try again.");
                }
            })
            .catch(error => {
                alert("An error occurred: " + error.message);
            });
    };
</script>
</body>
</html>
