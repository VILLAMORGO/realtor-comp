import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("connected");
    const messages = document.getElementById("messages");
    this.autoScrollAnchor = document.createElement("div");
    this.autoScrollAnchor.id = "auto-scroll-anchor";
    messages.appendChild(this.autoScrollAnchor); // Add the anchor element at the end of the messages container

    // Create a MutationObserver to observe changes in the messages container
    this.observer = new MutationObserver(() => this.resetScroll());
    this.observer.observe(messages, { childList: true });

    // Reset the scroll initially
    this.resetScroll();
  }

  disconnect() {
    console.log("disconnected");

    // Disconnect the observer when the controller is disconnected
    if (this.observer) {
      this.observer.disconnect();
    }

    // Clean up the auto-scroll anchor element
    if (this.autoScrollAnchor) {
      this.autoScrollAnchor.remove();
    }
  }

  resetScroll() {
    setTimeout(() => {
      this.autoScrollAnchor.scrollIntoView({ behavior: "smooth" });
    }, 300); // Delay to ensure the DOM changes are applied before scrolling
  }
}