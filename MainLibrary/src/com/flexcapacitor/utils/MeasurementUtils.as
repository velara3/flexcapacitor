
// Adobe(R) Systems Incorporated Source Code License Agreement
// Copyright(c) 2006-2010 Adobe Systems Incorporated. All rights reserved.
//
// Please read this Source Code License Agreement carefully before using
// the source code.
//
// Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
// no-charge, royalty-free, irrevocable copyright license, to reproduce,
// prepare derivative works of, publicly display, publicly perform, and
// distribute this source code and such derivative works in source or
// object code form without any attribution requirements.
//
// The name "Adobe Systems Incorporated" must not be used to endorse or promote products
// derived from the source code without prior written permission.
//
// You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
// against any loss, damage, claims or lawsuits, including attorney's
// fees that arise or result from your use or distribution of the source
// code.
//
// THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
// ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
// BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
// NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL ADOBE
// OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
// OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
// OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

// Source from: https://github.com/cantrell/Reversi/blob/master/src/com/christiancantrell/utils/Ruler.as

// additional code added


package com.flexcapacitor.utils {
	

	public class MeasurementUtils {
		
		public static const MIN_BUTTON_SIZE_MM:uint = 8;
		public static const MIN_BUTTON_SIZE_INCHES:Number = 0.27559055;
		
		/**
		 * Convert inches to pixels.
		 */
		public static function inchesToPixels(inches:Number, dpi:uint):uint {
			return Math.round(dpi * inches);
		}
		
		/**
		 * Convert inches to millimeters.
		 */
		public static function inchesToMillimeters(inches:Number, fractionDigits:int = 2):Number {
			var value:Number = Number(Number(inches * 25.4).toFixed(fractionDigits));
			return value;
		}
		
		/**
		 * Convert millimeters to pixels.
		 */
		public static function millimetersToPixels(mm:Number, dpi:uint):uint {
			return Math.round(dpi * (mm / 25.4));
		}
		
		/**
		 * Convert millimeters to inches.
		 */
		public static function millimetersToInches(mm:Number, fractionDigits:int = 2):Number {
			//var value:Number = Number(Number(mm / 25.4).toFixed(fractionDigits));
			var value:Number = Number(Number(mm * .03937).toFixed(fractionDigits)); 
			return value;
		}
		
		/**
		 * Convert pixels to inches.
		 */
		public static function pixelsToInches(pixels:uint, dpi:uint, fractionDigits:int = 2):Number {
			return Number(Number(pixels/dpi).toFixed(fractionDigits));
		}
		
		/**
		 * Convert pixels to millimeters
		 */
		public static function pixelsToMillimeters(pixels:uint, dpi:uint, fractionDigits:int = 2):Number {
			var value:Number = Number(Number(Number(pixels * 25.4)/dpi).toFixed(fractionDigits)); // so many casting :P
			return value;
		}
	}
}