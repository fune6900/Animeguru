import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["seichi", "address", "postalcode", "suggestions"]

  connect() {
    this.seichiTarget.addEventListener("input", this.autocomplete.bind(this))
  }

  autocomplete() {
    const query = this.seichiTarget.value.trim()
    if (query.length === 0) {
      this.clearSuggestions()
      return
    }

    fetch(`/api/seichi_search_suggestions?query=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => {
        this.showSuggestions(data)
      })
      .catch(error => console.error("オートコンプリートエラー:", error))
  }

  showSuggestions(suggestions) {
    this.clearSuggestions()

    suggestions.forEach(item => {
      const li = document.createElement("li")
      li.textContent = item.name
      li.classList.add("cursor-pointer", "hover:bg-gray-200", "px-2", "py-1")
      li.addEventListener("click", () => this.selectSuggestion(item))
      this.suggestionsTarget.appendChild(li)
    })
  }

  selectSuggestion(item) {
    this.seichiTarget.value = item.name
    this.addressTarget.value = item.address?.replace(/^日本、/, '').replace(/〒\d{3}-\d{4}/, '').trim() || ""
    this.postalcodeTarget.value = item.postal_code || ""
    this.clearSuggestions()
  }

  clearSuggestions() {
    this.suggestionsTarget.innerHTML = ""
  }
}
