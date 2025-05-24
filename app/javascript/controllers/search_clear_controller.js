import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "form", "input", "select" ]

  clear(event) {
    event.preventDefault()
    
    this.inputTargets.forEach(input => {
      input.value = ""
    })
    
    this.selectTargets.forEach(select => {
      select.selectedIndex = 0
    })
    
    this.formTarget.requestSubmit()
  }
}
