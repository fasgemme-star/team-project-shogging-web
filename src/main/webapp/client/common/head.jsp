<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&amp;family=Work+Sans:wght@400;500;600&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .active-view { display: block !important; }
        .hidden-view { display: none !important; }
        .transition-all-200 { transition: all 0.2s ease-in-out; }
        
        .glass-card {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
        }

        .nav-link-active {
            color: #3e6a00 !important;
            border-bottom: 2px solid #3e6a00;
        }

        .sub-tab-active {
            color: #3e6a00 !important;
            border-color: #3e6a00 !important;
            font-weight: 700;
        }

        #toast {
            visibility: hidden;
            min-width: 250px;
            margin-left: -125px;
            background-color: #333;
            color: #fff;
            text-align: center;
            border-radius: 8px;
            padding: 16px;
            position: fixed;
            z-index: 100;
            left: 50%;
            bottom: 30px;
        }

        #toast.show {
            visibility: visible;
            animation: fadein 0.5s, fadeout 0.5s 2.5s;
        }

        @keyframes fadein { from {bottom: 0; opacity: 0;} to {bottom: 30px; opacity: 1;} }
        @keyframes fadeout { from {bottom: 30px; opacity: 1;} to {bottom: 0; opacity: 0;} }
    </style>
<script id="tailwind-config">
        tailwind.config = {
          darkMode: "class",
          theme: {
            extend: {
              "colors": {
                      "secondary": "#1b6d24",
                      "surface-variant": "#e5e2e1",
                      "surface": "#fcf9f8",
                      "secondary-fixed-dim": "#88d982",
                      "background": "#fcf9f8",
                      "tertiary-fixed-dim": "#c6c6c7",
                      "surface-bright": "#fcf9f8",
                      "on-primary": "#ffffff",
                      "on-primary-fixed-variant": "#2e4f00",
                      "surface-container": "#f0eded",
                      "inverse-on-surface": "#f3f0ef",
                      "on-secondary-container": "#217128",
                      "tertiary-fixed": "#e2e2e2",
                      "on-tertiary-container": "#434546",
                      "inverse-primary": "#9ed75b",
                      "secondary-fixed": "#a3f69c",
                      "inverse-surface": "#303030",
                      "on-surface-variant": "#424939",
                      "surface-tint": "#3e6a00",
                      "on-tertiary-fixed": "#1a1c1c",
                      "on-error": "#ffffff",
                      "tertiary": "#5d5f5f",
                      "on-primary-fixed": "#0f2000",
                      "primary": "#3e6a00",
                      "on-secondary": "#ffffff",
                      "on-tertiary": "#ffffff",
                      "error": "#ba1a1a",
                      "on-error-container": "#93000a",
                      "error-container": "#ffdad6",
                      "surface-dim": "#dcd9d9",
                      "on-background": "#1b1c1c",
                      "primary-fixed": "#b9f474",
                      "on-secondary-fixed": "#002204",
                      "surface-container-low": "#f6f3f2",
                      "secondary-container": "#a0f399",
                      "surface-container-lowest": "#ffffff",
                      "surface-container-highest": "#e5e2e1",
                      "primary-fixed-dim": "#9ed75b",
                      "surface-container-high": "#eae7e7",
                      "tertiary-container": "#b2b3b3",
                      "on-secondary-fixed-variant": "#005312",
                      "on-tertiary-fixed-variant": "#454747",
                      "on-primary-container": "#2d4e00",
                      "outline-variant": "#c2c9b4",
                      "primary-container": "#8bc34a",
                      "on-surface": "#1b1c1c",
                      "outline": "#737a67"
              },
              "borderRadius": {
                      "DEFAULT": "0.25rem",
                      "lg": "0.5rem",
                      "xl": "0.75rem",
                      "full": "9999px"
              },
              "spacing": {
                      "gutter-md": "24px",
                      "gutter-xs": "8px",
                      "max-width": "1200px",
                      "margin-mobile": "16px",
                      "base": "4px",
                      "gutter-sm": "16px",
                      "margin-desktop": "48px"
              },
              "fontFamily": {
                      "headline-lg": ["Plus Jakarta Sans"],
                      "headline-md": ["Plus Jakarta Sans"],
                      "headline-sm": ["Plus Jakarta Sans"],
                      "body-lg": ["Work Sans"],
                      "body-md": ["Work Sans"],
                      "body-sm": ["Work Sans"]
              }
            }
          }
        }
    </script>
</head>
