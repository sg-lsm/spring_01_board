package org.lsm.spring01.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.lsm.spring01.dto.PageRequestDTO;
import org.lsm.spring01.dto.TodoDTO;
import org.lsm.spring01.service.TodoService;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.validation.Valid;

@Controller
@RequestMapping("/todo")
@Log4j2
@RequiredArgsConstructor
public class TodoController {

    private final TodoService service;

    @GetMapping("/list")
    public void list(@Valid PageRequestDTO requestDTO, BindingResult bindingResult, Model model){
        log.info(requestDTO);
        if(bindingResult.hasErrors()){
            requestDTO = PageRequestDTO.builder().build();
        }
        model.addAttribute("resDTO", service.getList(requestDTO));
    }

//    @RequestMapping(value = "/register", method = RequestMethod.GET)

    @GetMapping("/regist")
    public void getRegister(){
        log.info("register here... GET");
    }

    @PostMapping("/regist")
    public String postRegister(@Valid TodoDTO dto, RedirectAttributes redirectAttributes, BindingResult result){
        log.info("register here... POST");
        log.info(dto);
        if(result.hasErrors()){
            log.info("has errors...");
            redirectAttributes.addFlashAttribute("errors", result.getAllErrors());
            return "/todo/regist";
        }

        log.info(dto);

        service.register(dto);

        return "redirect:/todo/list";
    }

    @GetMapping({"/read", "/modify"})
    public void read(Long tno,PageRequestDTO pageRequestDTO, Model model){
        TodoDTO todoDTO = service.getOne(tno);
        log.info(todoDTO);
        model.addAttribute("dto", todoDTO);
    }

    @PostMapping("/remove")
    public String remove(Long tno,PageRequestDTO reqDTO, RedirectAttributes redirectAttributes, PageRequestDTO pageRequestDTO) {
        log.info("----remove----");
        log.info("tno : " + tno);

        service.remove(tno);

//        redirectAttributes.addAttribute("page", 1);
//        redirectAttributes.addAttribute("size", reqDTO.getSize());

        return "redirect:/todo/list?" + pageRequestDTO.getLink();
    }

    @PostMapping("/modify")
    public String modify(@Valid TodoDTO dto, RedirectAttributes redirectAttributes, BindingResult bindingResult, PageRequestDTO reqDTO){

        if(bindingResult.hasErrors()){
            log.info("bindingResult Error...");
            redirectAttributes.addFlashAttribute("errors", bindingResult.getAllErrors());
            redirectAttributes.addAttribute("tno", dto.getTno());
            return "redirect:/todo/modify";
        }

        log.info(dto);
        service.modify(dto);

//        redirectAttributes.addAttribute("page", reqDTO.getPage());
//        redirectAttributes.addAttribute("size", reqDTO.getSize());

        redirectAttributes.addAttribute("tno", dto.getTno());

        return "redirect:/todo/read";
    }
}
