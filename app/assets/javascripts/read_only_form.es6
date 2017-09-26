class ReadOnlyForm {

  constructor(){ this.init(); }

  init() { 
    $('.readonly').find('input, select,textarea').attr('disabled', 'disabled' );
    $('.readonly').find('.help-block').remove();
   }

}
