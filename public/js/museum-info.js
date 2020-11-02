let bool = true;
window.mainInterval = setInterval(function(){
  if(window.CustomElements.ready && bool)
  {
    bool = false;
    main();
    clearInterval(window.mainInterval);
  }
  if (!bool) {
    clearInterval(window.mainInterval);
  }
}, 500);

function main() {
    new Page.MuseumInfo();
}
