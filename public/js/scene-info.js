window.mainInterval = setInterval(function(){
  if(window.CustomElements.ready)
  {
    main();
    clearInterval(window.mainInterval);
  }
}, 500);

function main() {
        new Page.SceneInfo();
}
