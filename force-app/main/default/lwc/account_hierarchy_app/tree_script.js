const onload = (items) => {  
    let toggler = items;
    let i;
    for (i = 0; i < toggler.length; i++) {
        toggler[i].addEventListener("click", function() {
          this.parentElement.querySelector(".nested").classList.toggle("active");
          this.classList.toggle("check-box");
        });
      }
}
export { onload };