document.addEventListener("keydown", function(event) {
    if (event.altKey && event.code === "Enter") {
        window.location = "/login"
    }
});
