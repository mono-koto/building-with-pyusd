// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {LibString} from "solady/Milady.sol";
import {Base64} from "solady/Milady.sol";

library Renderer {
    function tokenURI(uint256 tokenId) internal pure returns (string memory) {
        bytes memory jsonData = abi.encodePacked(
            '{"name": "HIPYUSD #',
            LibString.toString(tokenId),
            '",',
            '"description": "Open edition, onchain art celebrating PYUSD. 1 PYUSD per mint",',
            '"image": "',
            abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(svg(tokenId))),
            '"}'
        );

        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(jsonData)));
    }

    function svg(uint256 tokenId) internal pure returns (bytes memory) {
        return abi.encodePacked(
            "<svg xmlns='http://www.w3.org/2000/svg' viewBox='-50 -50 100 100'>",
            defs(tokenId),
            styles(),
            "<g id='container' fill='",
            tokenId % 2 == 0 ? "white" : "black",
            "'>",
            "<g class='rotation rotateZ'>",
            "<g class='rotation rotateY'>",
            "<g id='cardBody'>",
            "<rect class='bg' width='100%' height='100%' rx='10' ry='10' />",
            "<svg width='100%' height='66%' y='16%' viewBox='0 0 48 48' >",
            "<path d='M27.8122 9.60547H25.177H19.3683C18.4332 9.60547 17.6115 10.2855 17.4698 11.2206L16.8748 15.0458V15.0742H14.0412C13.2762 15.0742 12.6811 15.6976 12.6811 16.4343C12.6811 17.1993 13.3045 17.7944 14.0412 17.8227H16.4497L16.0247 20.4579L15.9964 20.6562H13.1628C12.3978 20.6562 11.8027 21.2796 11.8027 22.0163C11.8027 22.753 12.4261 23.3764 13.1628 23.3764H15.5713L14.2679 31.622L13.8429 34.3705L13.6162 35.844C13.4462 37.0057 14.3246 38.0541 15.5147 38.0541H17.3281H19.8216H21.8618C22.7968 38.0541 23.5902 37.3741 23.7602 36.439L24.9787 28.8735H25.687H27.9539C33.3092 28.8735 37.6729 24.4532 37.5879 19.0695C37.5029 13.7708 33.0825 9.60547 27.8122 9.60547ZM19.2266 17.8227L27.7838 17.851C28.5489 17.851 29.2006 18.4744 29.2006 19.2678C29.2006 20.0329 28.5772 20.6846 27.7838 20.6846H18.7732L19.2266 17.8227ZM27.8405 26.0966H26.3954H25.7154H24.2703C23.3352 26.0966 22.5418 26.7767 22.3718 27.7117L21.1534 35.3056H16.5064L18.3482 23.4048H27.7838C30.079 23.4048 31.9208 21.5346 31.9208 19.2678C31.9208 17.001 30.0507 15.1309 27.7838 15.1309L19.6799 15.1025L20.105 12.3823H27.9822C31.8358 12.3823 34.9527 15.5559 34.8677 19.4095C34.7543 23.1497 31.6091 26.0966 27.8405 26.0966Z'  />",
            "</svg>",
            "<g>",
            "<text y='83%' x='50%' class='text bold hello'>HIPYUSD</text>",
            "<text y='93%' x='50%' class='text bold tokenId'>",
            LibString.toString(tokenId),
            "</text>",
            "</g></g></g></g></g></svg>"
        );
    }

    function defs(uint256 tokenId) internal pure returns (bytes memory) {
        uint256 h = uint256(keccak256(abi.encodePacked(tokenId)));
        uint256 cx = h % 100;
        uint256 cy = (h >> 8) % 100;

        return abi.encodePacked(
            "<defs>",
            "<radialGradient id='gradient' cx='",
            LibString.toString(cx),
            "%' cy='",
            LibString.toString(cy),
            "%' r='1'>",
            "<animate attributeName='r' values='1;2;1' dur='10s' repeatCount='indefinite'/>",
            gradientStop(h >> 16, 0),
            gradientStop(h >> 17, 50),
            gradientStop(h >> 18, 100),
            "</radialGradient>",
            "</defs>"
        );
    }

    function gradientStop(uint256 v, uint256 i) internal pure returns (string memory) {
        return string(abi.encodePacked("<stop offset='", LibString.toString(i), "%' stop-color='", color(v), "' />"));
    }

    function color(uint256 v) internal pure returns (string memory) {
        v = v % 8;
        if (v == 0) return "red";
        if (v == 1) return "deeppink";
        if (v == 2) return "#0079C1";
        if (v == 3) return "#00457C";
        if (v == 4) return "purple";
        if (v == 5) return "fuscia";
        if (v == 6) return "pink";
        else return "cyan";
    }

    function styles() internal pure returns (bytes memory) {
        return abi.encodePacked(
            "<style>",
            ".tokenId{font-family:monospace;font-size:0.4em;text-anchor:middle;alignment-baseline:middle;font-size:0.7em;font-weight:bold}",
            ".hello{font-family:monospace;text-anchor:middle;font-size:0.3em;font-weight:bold}",
            ".bg{fill:url(#gradient)}",
            "#container{transform:scale(0.9)rotateX(12deg);transform-style:preserve-3d;filter:drop-shadow(0px 0px 2px #000)}",
            ".rotation{animation-timing-function:ease-in-out;animation-iteration-count:infinite;animation-direction:alternate;}",
            ".rotateY{animation-name:rotateY;animation-duration:7.5s;}",
            "@keyframes rotateY{0%{transform:rotateY(0)}33%{transform:rotateY(-30deg)}66%{transform:rotateY(0deg)}to{transform:rotateY(30deg)}}",
            ".rotateZ{animation-name:rotateZ;animation-duration:5.5s}",
            "@keyframes rotateZ{from{transform:rotateZ(-2deg)}to{transform:rotateZ(2deg)}}",
            "#cardBody{transform:translate(-50%, -50%)}",
            "</style>"
        );
    }
}
