class App {
 
  /* here we can call things we want to happen everywhere.. */
  constructor() {
    $( () => { 
      /* Make form date inputs use jquery datepicker */ 
      $('.datepicker').datepicker({ dateFormat: "yy-mm-dd" });
      /* Turn our show pages into read-only forms */ 
      new ReadOnlyForm(); 
      new StatusUpdate();
  }) 

  }

}

const app = new App();
