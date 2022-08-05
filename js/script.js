window.onload = () => {
	meter.onchange = () => {
		range.innerHTML = ' - ' + meter.value;
	}
	// setTimeout(removealert, 10000);
}


function removealert() {
	for (let i = 0; i < alert.length; i++) {
		if(alert[i])
			alert[i].hidden = true;
	}
	
}

const meter = document.getElementById("meter");
const range = document.getElementById("range");

const alert = document.getElementsByClassName("myalert");