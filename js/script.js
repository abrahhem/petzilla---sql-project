window.onload = () => {
	meter.onchange = () => {
		range.innerHTML = ' - ' + meter.value;
	}
	p3_order_id.innerHTML = p1_order_id.innerHTML;
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

const p1_order_id = document.getElementById("P1OrderID");
const p3_order_id = document.getElementById("p3OrderID");