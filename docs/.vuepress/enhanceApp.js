import Element from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css';
export default async ({Vue,isServer,router}) => {
    Vue.use(Element);
    Vue.use(router);
    if(!isServer){
        router.beforeEach((to,from,next) => {
            console.log(to,from)
            if(to.path === '/'){
                next('/gon')
            }else {
                next()
            }
        })
        await import("axios").then(module => {
            console.log(module)
            Vue.prototype.$axios = module.default
        })
        await import('element-ui').then(module => {
            Vue.use(module.default)
        }).catch(e => {
            console.log(e, 'element-ui error ')
        })
    }
}