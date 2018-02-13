#![no_std]
#![feature(lang_items)]

#[lang = "panic_fmt"]
extern fn panic_fmt(_: ::core::fmt::Arguments, _: &'static str, _: u32) -> ! {
    loop {}
}

#[lang = "eh_personality"]
extern fn eh_personality() {
    loop {}
}

#[no_mangle]
pub extern fn rust_begin_unwind() {
    loop {}
}

#[no_mangle]
pub extern "C" fn kernel_main() {
    loop { }
}
