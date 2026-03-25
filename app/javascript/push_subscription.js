function urlBase64ToUint8Array(base64String) {
  const padding = "=".repeat((4 - base64String.length % 4) % 4);
  const base64 = (base64String + padding)
    .replace(/-/g, "+")
    .replace(/_/g, "/");

  const rawData = window.atob(base64);
  return Uint8Array.from([...rawData].map((char) => char.charCodeAt(0)));
}

async function enablePush() {
  console.log("enablePush 開始");

  if (!("serviceWorker" in navigator)) {
    console.log("serviceWorker 非対応");
    alert("この端末は Service Worker に対応していません。");
    return;
  }

  if (!("PushManager" in window)) {
    console.log("PushManager 非対応");
    alert("この端末は Push 通知に対応していません。");
    return;
  }

  console.log("Notification.permission 前:", Notification.permission);
  console.log("window.vapidPublicKey:", window.vapidPublicKey);

  const permission = await Notification.requestPermission();
  console.log("permission:", permission);

  if (permission !== "granted") {
    alert("通知が許可されませんでした。");
    return;
  }

  try {
    const registration = await navigator.serviceWorker.ready;
    console.log("service worker ready:", registration);

    let subscription = await registration.pushManager.getSubscription();
    console.log("既存 subscription:", subscription);

    if (!subscription) {
      console.log("新規 subscription を作成します");

      subscription = await registration.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: urlBase64ToUint8Array(window.vapidPublicKey)
      });

      console.log("新規 subscription 作成成功:", subscription);
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

    console.log("POST /push_subscription status:", response.status);

    if (!response.ok) {
      alert("通知設定の保存に失敗しました。");
      return;
    }

    alert("通知を有効にしました。");
  } catch (error) {
    console.error("enablePush エラー:", error);
    alert("通知設定中にエラーが発生しました。Console を確認してください。");
  }
}

document.addEventListener("turbo:load", () => {
  console.log("turbo:load 発火");

  const btn = document.getElementById("enable-push-btn");
  console.log("btn:", btn);

  if (!btn) return;

  btn.addEventListener("click", enablePush);
});