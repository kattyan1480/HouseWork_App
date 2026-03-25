function urlBase64ToUint8Array(base64String) {
  const padding = "=".repeat((4 - base64String.length % 4) % 4);
  const base64 = (base64String + padding)
    .replace(/-/g, "+")
    .replace(/_/g, "/");

  const rawData = window.atob(base64);
  return Uint8Array.from([...rawData].map((char) => char.charCodeAt(0)));
}

async function enablePush() {
  if (!("serviceWorker" in navigator)) {
    alert("この端末は Service Worker に対応していません。");
    return;
  }

  if (!("PushManager" in window)) {
    alert("この端末は Push 通知に対応していません。");
    return;
  }

  const permission = await Notification.requestPermission();

  if (permission !== "granted") {
    alert("通知が許可されませんでした。");
    return;
  }

  const registration = await navigator.serviceWorker.ready;

  let subscription = await registration.pushManager.getSubscription();

  if (!subscription) {
    subscription = await registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: urlBase64ToUint8Array(window.vapidPublicKey)
    });
  }

  const response = await fetch("/push_subscription", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
    },
    body: JSON.stringify({
      subscription: subscription.toJSON()
    })
  });

  if (!response.ok) {
    alert("通知設定の保存に失敗しました。");
    return;
  }

  alert("通知を有効にしました。");
}

document.addEventListener("turbo:load", () => {
  const btn = document.getElementById("enable-push-btn");
  if (!btn) return;

  btn.addEventListener("click", enablePush);
});