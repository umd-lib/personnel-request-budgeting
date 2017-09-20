class ReadOnlyForm {

  constructor(){ this.init(); }

  init() { 
    $('.readonly').find('input, select,textarea').attr('disabled', 'disabled' );
    $('.help-block').remove();
   }

}
