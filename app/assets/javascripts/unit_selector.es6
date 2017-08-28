class UnitSelector {

  constructor(){ this.init(); }

  init() { 

    $('.department-select').on( 'change', (e)=>  {
      let dept_id = parseInt(e.target.value); 
      let units = new Set(depts_and_units[dept_id]); 
      $('.unit-select option').each( (i, el)=> { 
        let $el = $(el); 
        if ( units.has(parseInt(el.value)) || el.value === "" ) { $el.show(); } 
        else { $el.hide(); }
      });  
       
    });
   
    $('.department-select').change();
  }
}
