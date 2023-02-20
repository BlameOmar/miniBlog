document.addEventListener("keydown", function(event) {
    if (event.altKey && event.code === "Enter") {
        alert('Login key combo');
        e.preventDefault();
    }
});
