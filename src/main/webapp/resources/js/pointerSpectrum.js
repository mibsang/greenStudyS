/**
 * 마우스 효과
 *  - 기본: 붓 잔상 (지나간 자리가 잠깐 남았다 사라짐)
 *  - ESC 1번: 낙서 모드 (지나간 자리에 선이 계속 남음)
 *  - ESC 1번 더: 낙서를 지우고 다시 잔상 모드로
 */
'use strict';

(() => {
  // 잔상 모드 설정
  const LIFE = 500;          // 잔상이 남는 시간(ms)
  const MAX_WIDTH = 14;      // 가장 굵을 때 선 두께(px)
  // 낙서 모드 설정
  const DOODLE_MAX_WIDTH = 6;   // 천천히 움직일 때 선 두께(px)
  const DOODLE_MIN_WIDTH = 2;   // 빠르게 움직일 때 선 두께(px)
  // 공통 설정
  const MIN_DIST = 2;        // 이보다 가까운 좌표는 무시 (떨림 방지)
  const COLOR = 'rgb(30, 30, 30)';  // 선 색 (투명도는 아래 OPACITY로)
  const OPACITY = 0.85;      // 선 전체 투명도

  function makeCanvas() {
    const canvas = document.createElement('canvas');
    canvas.style.cssText =
      'position:fixed; inset:0; pointer-events:none; z-index:9999; opacity:' + OPACITY + ';';
    document.body.appendChild(canvas);
    return canvas;
  }

  function init() {
    const canvas = makeCanvas();          // 잔상용 (매 프레임 지우고 다시 그림)
    const ctx = canvas.getContext('2d');
    const doodleCanvas = makeCanvas();    // 낙서용 (지우지 않고 계속 쌓음)
    const dctx = doodleCanvas.getContext('2d');

    let doodleMode = false;   // false = 잔상 모드, true = 낙서 모드

    // 잔상 모드 상태
    let points = [];
    let smoothSpeed = 0;

    // 낙서 모드 상태
    let last = null;       // 직전 마우스 좌표
    let lastMid = null;    // 직전 구간이 끝난 지점 (곡선 연결용)
    let doodleSpeed = 0;
    let dpr = window.devicePixelRatio || 1;

    function resize() {
      // 낙서 캔버스는 크기가 바뀌면 비워지므로 복사해 두었다가 다시 붙인다
      const saved = document.createElement('canvas');
      saved.width = doodleCanvas.width;
      saved.height = doodleCanvas.height;
      if (saved.width && saved.height) saved.getContext('2d').drawImage(doodleCanvas, 0, 0);
      const oldDpr = dpr;

      dpr = window.devicePixelRatio || 1;
      for (const [c, cx] of [[canvas, ctx], [doodleCanvas, dctx]]) {
        c.width = innerWidth * dpr;
        c.height = innerHeight * dpr;
        c.style.width = innerWidth + 'px';
        c.style.height = innerHeight + 'px';
        cx.setTransform(dpr, 0, 0, dpr, 0, 0);
      }
      if (saved.width && saved.height) dctx.drawImage(saved, 0, 0, saved.width / oldDpr, saved.height / oldDpr);

      dctx.strokeStyle = COLOR;
      dctx.lineCap = 'round';
      dctx.lineJoin = 'round';
    }
    resize();
    window.addEventListener('resize', resize);

    // ===== 마우스 이동 =====
    document.addEventListener('mousemove', (e) => {
      if (doodleMode) drawDoodle(e.clientX, e.clientY);
      else addTrailPoint(e.clientX, e.clientY);
    });

    // 잔상 모드: 점만 모아 두고, 그리기는 draw()에서
    function addTrailPoint(x, y) {
      const last = points[points.length - 1];
      if (last) {
        const dist = Math.hypot(x - last.x, y - last.y);
        if (dist < MIN_DIST) return;
        smoothSpeed = smoothSpeed * 0.8 + dist * 0.2;   // 속도를 부드럽게 평균
      }
      const speedFactor = Math.max(0.35, 1 - smoothSpeed / 60);  // 빠를수록 가늘게
      points.push({ x, y, t: performance.now(), w: MAX_WIDTH * speedFactor });
    }

    // 낙서 모드: 직전 중간점 → 이번 중간점까지 곡선 한 토막을 바로 그림
    function drawDoodle(x, y) {
      const p = { x, y };
      if (!last) {
        last = p;
        lastMid = p;
        return;
      }
      const dist = Math.hypot(p.x - last.x, p.y - last.y);
      if (dist < MIN_DIST) return;
      doodleSpeed = doodleSpeed * 0.8 + dist * 0.2;
      const speedFactor = Math.min(1, doodleSpeed / 40);  // 빠를수록 가늘게

      const mid = { x: (last.x + p.x) / 2, y: (last.y + p.y) / 2 };
      dctx.lineWidth = DOODLE_MAX_WIDTH - (DOODLE_MAX_WIDTH - DOODLE_MIN_WIDTH) * speedFactor;
      dctx.beginPath();
      dctx.moveTo(lastMid.x, lastMid.y);
      dctx.quadraticCurveTo(last.x, last.y, mid.x, mid.y);
      dctx.stroke();

      last = p;
      lastMid = mid;
    }

    // 마우스가 창 밖으로 나가면 낙서 선을 끊는다 (다시 들어올 때 엉뚱한 직선 방지)
    document.addEventListener('mouseout', (e) => {
      if (!e.relatedTarget) last = null;
    });

    // ===== ESC: 모드 전환 =====
    document.addEventListener('keydown', (e) => {
      if (e.key !== 'Escape') return;
      doodleMode = !doodleMode;

      if (doodleMode) {
        // 잔상 → 낙서: 남아 있던 잔상은 비우고 낙서 시작
        points = [];
        last = null;
        doodleSpeed = 0;
      } else {
        // 낙서 → 잔상: 낙서를 전부 지우고 잔상 모드로
        dctx.clearRect(0, 0, innerWidth, innerHeight);
        smoothSpeed = 0;
      }
    });

    // ===== 잔상 그리기 (기존 코드 그대로) =====
    // 점들을 지나는 부드러운 곡선 경로
    function traceSmooth(pts, isFirst) {
      if (isFirst) ctx.moveTo(pts[0].x, pts[0].y);
      else ctx.lineTo(pts[0].x, pts[0].y);
      for (let i = 1; i < pts.length - 1; i++) {
        const midX = (pts[i].x + pts[i + 1].x) / 2;
        const midY = (pts[i].y + pts[i + 1].y) / 2;
        ctx.quadraticCurveTo(pts[i].x, pts[i].y, midX, midY);
      }
      const end = pts[pts.length - 1];
      ctx.lineTo(end.x, end.y);
    }

    function draw() {
      const now = performance.now();
      points = points.filter(p => now - p.t < LIFE);
      ctx.clearRect(0, 0, innerWidth, innerHeight);

      const n = points.length;
      if (n >= 2) {
        const left = [], right = [];

        for (let i = 0; i < n; i++) {
          const p = points[i];
          const a = points[Math.max(0, i - 1)];
          const b = points[Math.min(n - 1, i + 1)];

          // 진행 방향에 수직인 방향(법선)
          const dx = b.x - a.x, dy = b.y - a.y;
          const len = Math.hypot(dx, dy) || 1;
          const nx = -dy / len, ny = dx / len;

          const life = 1 - (now - p.t) / LIFE;   // 1(새것) → 0(꼬리)
          const half = (p.w * life) / 2;

          left.push({ x: p.x + nx * half, y: p.y + ny * half });
          right.push({ x: p.x - nx * half, y: p.y - ny * half });
        }

        ctx.fillStyle = COLOR;

        // 붓 자국 모양 하나로 한 번에 칠하기
        ctx.beginPath();
        traceSmooth(left, true);
        traceSmooth(right.reverse(), false);
        ctx.closePath();
        ctx.fill();

        // 머리(마우스 위치) 부분을 둥글게
        const head = points[n - 1];
        const headLife = 1 - (now - head.t) / LIFE;
        ctx.beginPath();
        ctx.arc(head.x, head.y, (head.w * headLife) / 2, 0, Math.PI * 2);
        ctx.fill();
      }
      requestAnimationFrame(draw);
    }
    requestAnimationFrame(draw);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();