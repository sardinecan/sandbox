function review(app, lem) {
    XsltForms_xmlevents.dispatch(
        document.getElementById("review"),
        "callbackevent",
        null,
        null,
        null,
        null,
        {
            app: app,
            lem: lem
        }
    );
}
console.log("reviewer() est chagée")
