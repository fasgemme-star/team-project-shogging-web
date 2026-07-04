/* globals Chart:false */

(() => {
    'use strict';
    const canvas = document.getElementById("myChart");

    if (!canvas) {
        return;
    }

    const ctx = canvas.getContext("2d");

    new Chart(ctx, {
        type: "line",
        data: {
            labels: [
                "1월",
                "2월",
                "3월",
                "4월",
                "5월",
                "6월",
                "7월",
                "8월",
                "9월",
                "10월",
                "11월",
                "12월"
            ],
            datasets: [
                {
                    label: "회원 등록",
                    data: newClientData,
                    borderColor: "#5B7CFA",
                    backgroundColor: "rgba(91,124,250,0.15)",
                    borderWidth: 3,
                    fill: false,
                    tension: 0.35,
                    pointRadius: 4,
                    pointHoverRadius: 7,
                    pointBackgroundColor: "#5B7CFA"
                },
                {
                    label: "회원 탈퇴",
                    data: dropOutData,
                    borderColor: "#EF5B5B",
                    backgroundColor: "rgba(239,91,91,0.15)",
                    borderWidth: 3,
                    fill: false,
                    tension: 0.35,
                    pointRadius: 4,
                    pointHoverRadius: 7,
                    pointBackgroundColor: "#EF5B5B"
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                mode: "index",
                intersect: false
            },
            plugins: {
                legend: {
                    display: true,
                    position: "top",
                    labels: {
                        usePointStyle: true,
                        pointStyle: "circle",
                        padding: 20,
                        font: {
                            size: 14,
                            weight: "bold"
                        }
                    }
                },
                tooltip: {
                    enabled: true,
                    backgroundColor: "#ffffff",
                    titleColor: "#333333",
                    bodyColor: "#333333",
                    borderColor: "#dddddd",
                    borderWidth: 1,
                    displayColors: true,
                    padding: 12
                }
            },
            scales: {
                x: {
                    grid: {
                        display: false
                    },
                    ticks: {
                        color: "#666",
                        font: {
                            size: 13
                        }
                    }
                },
                y: {
                    beginAtZero: true,
                    grid: {
                        color: "#eeeeee"
                    },
                    ticks: {
                        color: "#666",
                        font: {
                            size: 13
                        }
                    }
                }
            }
        }
    });
})();
